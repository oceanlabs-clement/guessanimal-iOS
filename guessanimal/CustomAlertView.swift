//
//  CustomAlertView.swift
//  guessanimal
//
//  Created by Clement Gan on 05/11/2024.
//

import UIKit

// Define a custom alert view
class CustomAlertView: UIView {
    
    // Declare UI components for title, message, and button
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let okButton = UIButton()
    
    // Properties to store title and message
    private var titleText: String
    private var messageText: String
    
    // Closure to handle the dismissal (communication with the parent view)
    var dismissHandler: (() -> Void)?
    
    // Initializer with title and message parameters
    init(title: String, message: String) {
        self.titleText = title
        self.messageText = message
        super.init(frame: .zero)
        
        // Background view (for dimming the screen)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        // Container for the alert content
        let alertContainer = UIView()
        alertContainer.backgroundColor = .white
        alertContainer.layer.cornerRadius = 15
        alertContainer.translatesAutoresizingMaskIntoConstraints = false
        alertContainer.layer.masksToBounds = true
        self.addSubview(alertContainer)
        
        // Title label setup
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Message label setup
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // OK button setup
        okButton.setTitle("Play Again", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = .systemBlue
        okButton.layer.cornerRadius = 10
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        // Add subviews to the container
        alertContainer.addSubview(titleLabel)
        alertContainer.addSubview(messageLabel)
        alertContainer.addSubview(okButton)
        
        // Set constraints for the container and subviews
        NSLayoutConstraint.activate([
            alertContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            alertContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            alertContainer.widthAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: alertContainer.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: alertContainer.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: alertContainer.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: alertContainer.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: alertContainer.trailingAnchor, constant: -20),
            
            okButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            okButton.bottomAnchor.constraint(equalTo: alertContainer.bottomAnchor, constant: -20),
            okButton.centerXAnchor.constraint(equalTo: alertContainer.centerXAnchor),
            okButton.widthAnchor.constraint(equalToConstant: 100),
            okButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // Required initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Show the alert with pop-up animation
    func show(in parentView: UIView) {
        parentView.addSubview(self)
        
        // Set constraints to cover the entire parent view (background)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parentView.topAnchor),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        ])
        
        // Set initial scale to 0 (hidden)
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        // Animate the alert with scaling effect
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
    
    // Dismiss the alert with animation
    @objc private func dismissAlert() {
        // Animate scale down and fade out
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            self.dismissHandler?() // Call the dismiss handler to communicate with the parent view
        }
    }
}
