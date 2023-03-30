//
//  CommentTextView.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 30.03.2023.
//

import UIKit

class CommentTextView: UITextView {
    //MARK: - Properties
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter comment"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
     private var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(postComment), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        placeholderLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        
        autoresizingMask = .flexibleHeight
        
        addSubview(postButton)
        postButton.backgroundColor = .red
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        postButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        postButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        
        print(postButton.frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    @objc func postComment() {
        print("Post")
    }
}
