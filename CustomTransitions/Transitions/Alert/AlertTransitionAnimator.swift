//
//  AlertTransitionAnimator.swift
//  PresentAlert
//
//  Created by Ondřej Korol on 20.06.2021.
//

import UIKit

class AlertTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum Transition {
        case presenting
        case dismissing
        
        var duration: TimeInterval {
            switch self {
            case .presenting:
                return 0.3
            case .dismissing:
                return 0.2
            }
        }
    }
    
    private static let scaleTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    
    let transition: Transition
    
    // MARK: Initialization
    init(transition: Transition) {
        self.transition = transition
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        transition.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewKey = transition == .presenting ? .to : .from
        
        guard let viewToAnimate = transitionContext.view(forKey: key) else {
            transitionContext.completeTransition(false)
            return
        }
        
        switch transition {
        case .presenting:
            let containerView = transitionContext.containerView
            containerView.addSubview(viewToAnimate)
            
            viewToAnimate.alpha = 0
            viewToAnimate.transform = Self.scaleTransform
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0) {
                viewToAnimate.alpha = 1
                viewToAnimate.transform = .identity
            } completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        case .dismissing:
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0, animations: {
                viewToAnimate.alpha = 0
                viewToAnimate.transform = Self.scaleTransform
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
