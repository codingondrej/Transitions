//
//  SlideTransitionAnimator.swift
//  CustomTransitions
//
//  Created by Ondřej Korol on 25.07.2021.
//

import UIKit

class SlideTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1. Get the view of the presented view controller
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        // 2. Add the view to the transition's container view
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        // 3. Prepare the view for an animation
        toView.layoutIfNeeded()
        toView.transform = CGAffineTransform(translationX: toView.bounds.width, y: .zero)
        
        // 4. Perform the actual animation
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.50, initialSpringVelocity: 0, animations: {
            toView.transform = .identity
        }) { _ in
            // 5. Tell UIKit that the transition should end
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
