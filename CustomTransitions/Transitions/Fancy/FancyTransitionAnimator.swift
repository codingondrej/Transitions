//
//  FancyTransitionAnimator.swift
//  CustomTransitions
//
//  Created by Ondřej Korol on 25.07.2021.
//

import UIKit

class FancyTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum Transition {
        case presenting
        case dismissing
        
        var duration: TimeInterval {
            return 1.5
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
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let fromColor = fromView.backgroundColor
        let toColor = toView.backgroundColor
        
        // Helper container view
        let colorView = UIView()
        colorView.alpha = 0
        colorView.backgroundColor = fromColor
        colorView.frame = fromView.frame
        containerView.addSubview(colorView)
        
        // Destination View
        containerView.addSubview(toView)
        toView.layoutIfNeeded()
        toView.alpha = 0
        
        // Helper label
        let fakeLabel = UILabel()
       
        let fromLabel = transition == .presenting ?
            (fromViewController as? HomeViewController)?.fancyButton.titleLabel :
            (fromViewController as? DetailViewController)?.titleLabel
        
        if let fromLabel = fromLabel {
            fakeLabel.text = fromLabel.text
            fakeLabel.font = fromLabel.font
            fakeLabel.textColor = fromLabel.textColor
            colorView.addSubview(fakeLabel)
            fakeLabel.frame = fromLabel.convert(fromLabel.bounds, to: nil)
        }
        
        let toLabel = transition == .presenting ?
            (toViewController as? DetailViewController)?.titleLabel :
            (toViewController as? HomeViewController)?.fancyButton.titleLabel
         
        var fakeLabelFinalRect: CGRect = .zero
        if let toLabel = toLabel {
            fakeLabelFinalRect = toLabel.convert(toLabel.bounds, to: nil)
        }
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                colorView.alpha = 1
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.50) {
                colorView.backgroundColor = toColor
                fakeLabel.frame = fakeLabelFinalRect
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                toView.alpha = 1
            }
        }) { _ in
            // Remove helper view
            colorView.removeFromSuperview()
            
            // Notifies the system that the transition animation is done
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
