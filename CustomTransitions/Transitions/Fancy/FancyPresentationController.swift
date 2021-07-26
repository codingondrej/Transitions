//
//  FancyPresentationController.swift
//  CustomTransitions
//
//  Created by Ondřej Korol on 25.07.2021.
//

import UIKit

class FancyPresentationController: UIPresentationController {
    // MARK: Presentation
    /**
     If false is returned from `shouldRemovePresentersView`, the view associated with UITransitionContext.view(forKey: from) is nil during presentation. This intended to be a hint that your animator should NOT be manipulating the presenting view controller's view. For a dismissal, the presentedView is returned.
     */
    override var shouldRemovePresentersView: Bool {
        return true
    }
}
