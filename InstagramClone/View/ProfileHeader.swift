//
//  ProfileHeader.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 24.03.2023.
//

import UIKit
import SDWebImage

class ProfileHeader: UICollectionReusableView {
    //MARK: - Properties
    
    var viewModel: ProfileHeaderViewModel? {
        didSet {
            configure()
        }
    }
    
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy private var editPorfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit profile", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(editProfileFollowTapped), for: .touchUpInside)
        return button
    }()
    
   lazy private var postsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedLabel(value: 10, label: "Posts")
        return label
    }()
    
    lazy private var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedLabel(value: 1, label: "Followers")
        return label
    }()
    
    lazy private var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedLabel(value: 2, label: "Following")
        return label
    }()
    
    lazy private var postsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "grid"), for: .normal)
        return button
    }()
    
    lazy private var savedButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ribbon"), for: .normal)

        return button
    }()
    
    lazy private var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "list"), for: .normal)

     
        return button
    }()
    
   lazy private var underline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        addSubview(profileImage)
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImage.layer.cornerRadius = 80 / 2
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 12).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        
        addSubview(editPorfileFollowButton)
        editPorfileFollowButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        editPorfileFollowButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        editPorfileFollowButton.widthAnchor.constraint(equalToConstant: self.frame.width - 48).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        stack.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 6).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
        let buttonStack = UIStackView(arrangedSubviews: [postsButton, listButton, savedButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(buttonStack)
        buttonStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        buttonStack.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        
        addSubview(underline)
        underline.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -15).isActive = true
        underline.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        underline.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func attributedLabel(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.fullName
        profileImage.sd_setImage(with: URL(string: viewModel.profileImageUrl))
    }
    
    //MARK: - Selectors
    
    @objc func editProfileFollowTapped() {
        print("DEBUG: edit profile button pressed")
    }
}
