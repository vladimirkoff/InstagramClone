//
//  NotificationCell.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 01.04.2023.
//

import UIKit
import SDWebImage

enum NotificationType {
    case likePost
    case follow
    case comment
}

protocol NotificationCellDelegate: class {
    func goToProfile(uid: String)
    func followButtonTapped(cell: NotificationCell, completion: @escaping(Bool) -> ())
    func checkIfFollowed(cell: NotificationCell, completion: @escaping(Bool) -> ())
    func goToPost(cell: NotificationCell)
}

class NotificationCell: UICollectionViewCell {
    //MARK: - Proeprties
    
    var viewModel: NotificationViewModel? {
        didSet {
            configureFollowButton()
            configure()
        }
    }
    
    var notificationType: NotificationType?
    weak var delegate: NotificationCellDelegate?
    
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
         return label
     }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy private var postImage: UIImageView = {
         let iv = UIImageView()
         iv.translatesAutoresizingMaskIntoConstraints = false
         iv.backgroundColor = .purple
         iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
         
         let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(goToPost))
        iv.addGestureRecognizer(gestureRecognizer)
         
         return iv
     }()
    
     private var underline: UIView = {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = .lightGray
         view.backgroundColor = .lightGray
         return view
     }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(followButtonTapepd), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        commentLabel.numberOfLines = 0
    
        addSubview(profileImage)
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.layer.cornerRadius = 40 / 2
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.layer.cornerRadius = 40 / 2
        profileImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(goToProfile))
        profileImage.addGestureRecognizer(gestureRecognizer)
        
        addSubview(username)
        username.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive = true
        username.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        addSubview(notificationLabel)
        notificationLabel.leftAnchor.constraint(equalTo: username.rightAnchor, constant: 2).isActive = true
        notificationLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
                
        addSubview(followButton)
        followButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -6).isActive = true
        followButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(postImage)
        postImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        postImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        postImage.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        postImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        postImage.layer.cornerRadius = 5
        
        addSubview(commentLabel)
        commentLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 5).isActive = true
        commentLabel.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 2).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: postImage.leftAnchor, constant: -4).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        
        addSubview(underline)
        underline.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 4).isActive = true
        underline.heightAnchor.constraint(equalToConstant: 1).isActive = true
        underline.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureFollowButton() {
        delegate?.checkIfFollowed(cell: self, completion: { isFollowed in
            self.checkIfFollowed(isFollowed: isFollowed)
        })
    }
    
    @objc func goToPost() {
        delegate?.goToPost(cell: self)
    }
    
    func checkIfFollowed(isFollowed: Bool) {
        if isFollowed {
            followButton.layer.borderColor = UIColor.black.cgColor
            followButton.layer.borderWidth = 1
            self.followButton.backgroundColor = .white
            self.followButton.tintColor = .black
        } else {
            followButton.layer.borderColor = UIColor.white.cgColor
            followButton.layer.borderWidth = 1
            self.followButton.backgroundColor = .systemBlue
            self.followButton.tintColor = .white
        }
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        guard let notificationType = notificationType else { return }
        
        switch notificationType {
        case .likePost:
            notificationLabel.text = "Liked your post"
            followButton.isHidden = true
            commentLabel.isHidden = true
            postImage.isHidden = false
        case .follow:
            notificationLabel.text = "Started following you"
            postImage.isHidden = true
            commentLabel.isHidden = true
            followButton.isHidden = false
        case .comment:
            notificationLabel.text = "Commented on your post:"
            postImage.isHidden = false
            followButton.isHidden = true
        }
        
        username.text = viewModel.notification.username
        profileImage.sd_setImage(with: URL(string: viewModel.notification.profileUrl))
        
        if !viewModel.notification.postImage.isEmpty {
            postImage.isHidden = false
            postImage.sd_setImage(with: URL(string: viewModel.notification.postImage))
        }
        
        if !viewModel.notification.commentText.isEmpty {
            commentLabel.isHidden = false
            commentLabel.text = viewModel.notification.commentText
        }
    }
    
    func configGestureRecognizer() -> UITapGestureRecognizer {
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(goToProfile))
        return gestureRecognizer
    }
    
    @objc func goToProfile() {
        guard let viewModel = viewModel else { return }
        delegate?.goToProfile(uid: viewModel.notification.uid)
    }
    
    @objc func followButtonTapepd() {
        delegate?.followButtonTapped(cell: self, completion: { isFollowed in
            self.checkIfFollowed(isFollowed: isFollowed)
        })
    }
    
}


