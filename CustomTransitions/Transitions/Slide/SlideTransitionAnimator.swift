//
//  SlideTransitionAnimator.swift
//  CustomTransitions
//
//  Created by Ondřej Korol on 25.07.2021.
//

import UIKit

class SlideTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum Transition {
        case presenting
        case dismissing
        
        var duration: TimeInterval {
            switch self {
            case .presenting:
                return 1.25
            case .dismissing:
                return 0.35
            }
        }
    }
    
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
        let duration = transitionDuration(using: transitionContext)
        let key: UITransitionContextViewKey = transition == .presenting ? .to : .from
        
        guard let viewToAnimate = transitionContext.view(forKey: key) else {
            transitionContext.completeTransition(false)
            return
        }
        
        switch transition {
        case .presenting:
            // Add presenting view controller's view to hierarchy
            let containerView = transitionContext.containerView
            containerView.addSubview(viewToAnimate)
            
            // Prepare view for animation
            viewToAnimate.layoutIfNeeded()
            viewToAnimate.transform = CGAffineTransform(translationX: viewToAnimate.bounds.width, y: .zero)
            
            // Animate view
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.50, initialSpringVelocity: 0, animations: {
                viewToAnimate.transform = .identity
            }) { _ in
                // Important! Notify the transition should end
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        case .dismissing:
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0, animations: {
                viewToAnimate.transform = CGAffineTransform(translationX: viewToAnimate.bounds.width, y: .zero)
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
