//
//  FancyTransitionManager.swift
//  CustomTransitions
//
//  Created by Ondřej Korol on 25.07.2021.
//

import UIKit

final class FancyTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FancyTransitionAnimator(transition: .presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FancyTransitionAnimator(transition: .dismissing)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return FancyPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}
