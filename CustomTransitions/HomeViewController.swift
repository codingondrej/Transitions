//
//  HomeViewController.swift
//  PresentAlert
//
//  Created by Ondřej Korol on 20.06.2021.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: Views
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var defaultButton: UIButton = {
        let button = UIButton.appButton()
        button.setTitle("Default", for: .normal)
        button.addTarget(self, action: #selector(didTapDefault), for: .touchUpInside)
        return button
    }()
    
    private lazy var slideButton: UIButton = {
        let button = UIButton.appButton()
        button.setTitle("Slide", for: .normal)
        button.addTarget(self, action: #selector(didTapSlide), for: .touchUpInside)
        return button
    }()
            
    private lazy var actionSheetButton: UIButton = {
        let button = UIButton.appButton()
        button.setTitle("Action Sheet", for: .normal)
        button.addTarget(self, action: #selector(didTapActionSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var alertButton: UIButton = {
        let button = UIButton.appButton()
        button.setTitle("Alert", for: .normal)
        button.addTarget(self, action: #selector(didTapAlert), for: .touchUpInside)
        return button
    }()
    
    lazy var fancyButton: UIButton = {
        let button = UIButton.appButton()
        button.setTitle("Fancy", for: .normal)
        button.addTarget(self, action: #selector(didTapFancy), for: .touchUpInside)
        return button
    }()
    
    // MARK: Transitions
    let slideTransitionManager = SlideTransitionManager()
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    let alertTransitionManager = AlertTransitionManager()
    let fancyTransitionManager = FancyTransitionManager()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
                
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        [defaultButton, slideButton, actionSheetButton, alertButton, fancyButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }
}

// MARK: - Private actions
private extension HomeViewController {
    @objc func didTapDefault(_ sender: UIButton) {
        let detailViewController = DetailViewController()
        detailViewController.title = sender.currentTitle
        
        present(detailViewController, animated: true)
    }
    
    @objc func didTapSlide(_ sender: UIButton) {
        let detailViewController = DetailViewController()
        detailViewController.title = sender.currentTitle
        
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = slideTransitionManager
        
        present(detailViewController, animated: true)
    }
    
    @objc func didTapActionSheet(_ sender: UIButton) {
        let detailViewController = DetailViewController()
        detailViewController.title = sender.currentTitle
        
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = actionSheetTransitionManager
        
        present(detailViewController, animated: true)
    }
    
    @objc func didTapAlert(_ sender: UIButton) {
        let detailViewController = DetailViewController()
        detailViewController.title = sender.currentTitle
        
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = alertTransitionManager
        
        present(detailViewController, animated: true)
    }
    
    @objc func didTapFancy(_ sender: UIButton) {
        let detailViewController = DetailViewController()
        detailViewController.title = sender.currentTitle
        
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = fancyTransitionManager
        
        present(detailViewController, animated: true)
    }
}
