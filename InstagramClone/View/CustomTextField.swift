//
//  CustomTextField.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 22.03.2023.
//

import UIKit

class CustomTextField: UITextField {
    
    //MARK: - Lifecycle
     init(placeholder: String) {
        super.init(frame: .zero)
         
        let space = UIView()
        space.translatesAutoresizingMaskIntoConstraints = false
        space.bounds = CGRect(x: 0, y: 0, width: 12, height: 50)
        leftView = space
        leftViewMode = .always
        
        translatesAutoresizingMaskIntoConstraints = false
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        isSecureTextEntry = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
