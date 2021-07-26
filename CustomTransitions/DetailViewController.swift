//
//  DetailViewController.swift
//  CustomTransitions
//
//  Created by Ondřej Korol on 25.07.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Views
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = title
        return label
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
        return label
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton.appButton()
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBlack
                
        // Subviews
        [titleLabel, textLabel, dismissButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        
        let inset: CGFloat = 24
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            titleLabel.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -inset),
            
            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: inset),
            textLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -inset),
            textLabel.bottomAnchor.constraint(equalTo: dismissButton.topAnchor, constant: -inset),
            
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -inset),
        ])
    }
    
    @objc private func didTapDismiss() {
        dismiss(animated: true)
    }
}

