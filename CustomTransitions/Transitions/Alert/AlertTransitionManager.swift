//
//  AlertTransitionManager.swift
//  PresentAlert
//
//  Created by Ondřej Korol on 20.06.2021.
//

import UIKit

final class AlertTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
        
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertTransitionAnimator(transition: .presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertTransitionAnimator(transition: .dismissing)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AlertPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}
