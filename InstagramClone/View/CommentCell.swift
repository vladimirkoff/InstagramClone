//
//  CommentCell.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 30.03.2023.
//

import UIKit
import SDWebImage

protocol CommentCellDelegate: class {
    func goToProfile(uid: String )
}

class CommentCell: UICollectionViewCell {
    //MARK: - Properties
    
    
    weak var delegate: CommentCellDelegate?
    
    var viewModel: CommentViewModel? {
        didSet {
            configure()
        }
    }
    
    private let timeStampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "12d"
        return label
    }()
    
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
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    func configGestureRecognizer() -> UITapGestureRecognizer {
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(goToProfile))
        return gestureRecognizer
    }
    
    @objc func goToProfile() {
        guard let viewModel = viewModel else { return }
        delegate?.goToProfile(uid: viewModel.comment.uid)
    }
    
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commentLabel.numberOfLines = 0
        
        addSubview(profileImage)
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.layer.cornerRadius = 40 / 2
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.layer.cornerRadius = 40 / 2
        
        addSubview(username)
        username.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive = true
        username.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
        
        addSubview(commentLabel)
        commentLabel.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 4).isActive = true
        commentLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
        addSubview(timeStampLabel)
        timeStampLabel.leftAnchor.constraint(equalTo: username.rightAnchor, constant: 2).isActive = true
        timeStampLabel.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        commentLabel.text = viewModel.text
        profileImage.sd_setImage(with: URL(string: viewModel.comment.profileUrl))
        username.text = viewModel.comment.username
    }
}
