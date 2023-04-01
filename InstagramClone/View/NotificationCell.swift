//
//  NotificationCell.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 01.04.2023.
//

import UIKit

enum NotificationType {
    case likePost
    case follow
    case likeComment
    case comment
    case reply
}

class NotificationCell: UITableViewCell {
    //MARK: - Proeprties
    
    lazy private var profileImage: UIImageView = {
         let iv = UIImageView()
         iv.translatesAutoresizingMaskIntoConstraints = false
         iv.backgroundColor = .purple
         iv.clipsToBounds = true
         iv.isUserInteractionEnabled = true
         iv.addGestureRecognizer(configGestureRecognizer())
         return iv
     }()
    
    lazy private var username: UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.textColor = .black
         label.font = UIFont.boldSystemFont(ofSize: 14)
         label.isUserInteractionEnabled = true
         label.addGestureRecognizer(configGestureRecognizer())
        label.text = "vladimir_12"
         return label
     }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Liked your post"
        return label
    }()
    
    lazy private var postImage: UIImageView = {
         let iv = UIImageView()
         iv.translatesAutoresizingMaskIntoConstraints = false
         iv.backgroundColor = .purple
         iv.isUserInteractionEnabled = true
         iv.addGestureRecognizer(configGestureRecognizer())
         return iv
     }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        addSubview(profileImage)
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.layer.cornerRadius = 40 / 2
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.layer.cornerRadius = 40 / 2
        
        addSubview(username)
        username.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive = true
        username.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        addSubview(notificationLabel)
        notificationLabel.leftAnchor.constraint(equalTo: username.rightAnchor, constant: 8).isActive = true
        notificationLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        addSubview(postImage)
        postImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        postImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        postImage.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        postImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        postImage.layer.cornerRadius = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configGestureRecognizer() -> UITapGestureRecognizer {
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(goToProfile))
        return gestureRecognizer
    }
    
    @objc func goToProfile() {
//        guard let viewModel = viewModel else { return }
//        delegate?.goToProfile(uid: viewModel.comment.uid)
    }
    
}


