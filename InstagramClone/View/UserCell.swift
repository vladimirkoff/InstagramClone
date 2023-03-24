//
//  UserCell.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 24.03.2023.
//

import UIKit

class UserCell: UITableViewCell {
    //MARK: - Properties
    
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "venom-7")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "vladimir"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Vladimir Kovalev"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        addSubview(profileImage)
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.layer.cornerRadius = 40 / 2
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, nameLabel])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = 1
        
        addSubview(stack)
        stack.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive = true
        stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6).isActive = true
    }
}
