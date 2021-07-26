//
//  ActionSheetPresentationController.swift
//  CustomTransitions
//
//  Created by Ondřej Korol on 25.07.2021.
//

import UIKit

final class ActionSheetPresentationController: UIPresentationController {
    
    // MARK: Constants
    private static let actionSheetCornerRadius: CGFloat = 30
    private static let dimmingViewMaxAlpha: CGFloat = 1.0
    
    // MARK: Views
    private lazy var dimmingView: UIView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    // MARK: Gesture Recognizers
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    // MARK: Initialization
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        configureGestureRecognizers()
    }
    
    // MARK: Presentation
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return .zero
        }
        
        let targetWidth = containerView.bounds.width
        let targetHeight = containerView.bounds.height * 0.6
        
        let originX: CGFloat = .zero
        let originY: CGFloat = containerView.bounds.height - targetHeight
        
        return CGRect(
            x: originX,
            y: originY,
            width: targetWidth,
            height: targetHeight
        )
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        dimmingView.frame = containerView?.bounds ?? .zero
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard
            let containerView = containerView,
            let coordinator = presentingViewController.transitionCoordinator
        else {
            return
        }
        
        presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedView?.layer.cornerRadius = Self.actionSheetCornerRadius
        
        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 0
        containerView.addSubview(dimmingView)
        
        coordinator.animate(
            alongsideTransition: { _ -> Void in
                self.dimmingView.alpha = Self.dimmingViewMaxAlpha
            },
            completion: nil
        )
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        guard let coordinator = presentingViewController.transitionCoordinator else {
            return
        }
        
        coordinator.animate(
            alongsideTransition: { _ -> Void in
                self.dimmingView.alpha = 0
            },
            completion: nil
        )
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
}

// MARK: - Private methods
private extension ActionSheetPresentationController {
    func configureGestureRecognizers() {
        tapGestureRecognizer.addTarget(self, action: #selector(handleTap))
        dimmingView.addGestureRecognizer(tapGestureRecognizer)
        
        panGestureRecognizer.addTarget(self, action: #selector(handlePan))
        presentedView?.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true)
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            guard
                let presentedView = presentedView
            else {
                return
            }
            
            let translationY = sender.translation(in: presentedView).y
            let originY = frameOfPresentedViewInContainerView.minY
            let updatedOriginY = originY + translationY
            
            // Update position
            presentedView.frame.origin.y = max(updatedOriginY, originY)
            
            // Update alpha
            if updatedOriginY >= originY {
                dimmingView.alpha = (1 - (translationY / presentedView.bounds.height)) * Self.dimmingViewMaxAlpha
            }
            
            // Workaround for inconsistent view layout during transition.
            // Adjusting safe area because safe area disappears when frame is changed.
            presentedViewController.additionalSafeAreaInsets.bottom = updatedOriginY > originY ?
                containerView?.safeAreaInsets.bottom ?? 0 :
                0.0
        case .ended:
            guard let presentedView = presentedView else {
                return
            }
            
            let velocityY = sender.velocity(in: presentedView).y
            let originY = frameOfPresentedViewInContainerView.minY
            let viewHeight = presentedView.frame.height
            
            // Dismiss only if the gesture is in the correct direction
            let directionCheck = velocityY > 0
            
            // Dismiss only if more than 40% of modal is hidden or there is a significant velocity
            let distanceCheck = presentedView.frame.origin.y > originY + (viewHeight * 0.4)
            let velocityCheck = velocityY > 500
            
            if directionCheck, distanceCheck || velocityCheck {
                presentedViewController.dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                    self.presentedView?.frame.origin.y = originY
                    self.dimmingView.alpha = Self.dimmingViewMaxAlpha
                    self.presentedViewController.additionalSafeAreaInsets.bottom = 0
                }
            }
        default:
            break
        }
    }
}
