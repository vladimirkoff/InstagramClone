//
//  CommentTextView.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 30.03.2023.
//

import UIKit


protocol CommentTextViewDelegate: class {
    func postComment(text: String)
}

class CommentTextView: UIView {
    //MARK: - Properties
    
    weak var delegate: CommentTextViewDelegate?
        
     var commentTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderLabel.text = "Enter comment"
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        
        return tv
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight

        addSubview(postButton)
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        postButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        postButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        addSubview(commentTextView)
        commentTextView.rightAnchor.constraint(equalTo: postButton.leftAnchor, constant: -8).isActive = true
        commentTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        commentTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        commentTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(divider)
        divider.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        divider.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
//    @objc func textDidChange() {
////        commentTextView.placeholderLabel.isHidden = !commentTextView.text.isEmpty
//    }

    @objc func postComment() {
        delegate?.postComment(text: commentTextView.text)
    }
}
