//
//  AlertPresentationController.swift
//  PresentAlert
//
//  Created by Ondřej Korol on 20.06.2021.
//

import UIKit

final class AlertPresentationController: UIPresentationController {
    
    // MARK: Constants
    private static let alertCornerRadius: CGFloat = 30
    private static let alertHorizontalInset: CGFloat = 24
    private static let dimmingViewMaxAlpha: CGFloat = 1.0
    
    // MARK: Views
    private lazy var dimmingView: UIView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    // MARK: Presentation
    override var frameOfPresentedViewInContainerView: CGRect {
        guard
            let containerView = containerView,
            let presentedView = presentedView
        else {
            return .zero
        }
            
        let safeAreaFrame = containerView.safeAreaLayoutGuide.layoutFrame
        
        let targetWidth = safeAreaFrame.width - 2 * Self.alertHorizontalInset
        let fittingSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )
        
        let targetHeight = presentedView.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        ).height

        return CGRect(
            x: containerView.center.x - targetWidth / 2,
            y: containerView.center.y - targetHeight / 2,
            width: targetWidth,
            height: targetHeight
        )
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedViewController.view.setNeedsLayout()
        presentedViewController.view.layoutIfNeeded()
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
        
        presentedView?.layer.cornerRadius = Self.alertCornerRadius
        
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
