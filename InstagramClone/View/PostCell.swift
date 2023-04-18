//
//  PostCell.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 21.03.2023.
//

import UIKit
import SDWebImage

protocol PostCellDelegate: AnyObject {
    func showOptions(cell: PostCell)
    func savePost(caption: String, image: UIImage, uuid: String, completion: @escaping(Bool) -> ())
    func usernameTapped(cell: PostCell)
    func likeTapped(post: Post, cell: PostCell, completion: @escaping(Error?, LikedUnliked) -> ())
    func commentTapped(post: Post)
    func shareTapped(cell: PostCell)
}

enum LikedUnliked {
    case liked
    case unliked
}

class PostCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var viewModel: PostViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: PostCellDelegate?
    
    private lazy var profileImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(configureGestureRec())
        return iv
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        return button
    }()
    
    private let postImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(commentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "send2"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        return button
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.text = "0 like"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "dots"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(optionsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        addSubview(profileImage)
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.layer.cornerRadius = 40 / 2
        
        addSubview(usernameButton)
        usernameButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        usernameButton.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive
        = true
        
        addSubview(postImage)
        postImage.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8).isActive = true
        postImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        postImage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        postImage.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 8).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
        addSubview(likesLabel)
        likesLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        likesLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 8).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        
        addSubview(captionLabel)
        captionLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 8).isActive = true
        captionLabel.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 4).isActive = true
        
        addSubview(postTimeLabel)
        postTimeLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
        postTimeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        
        addSubview(optionsButton)
        optionsButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        optionsButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        optionsButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        optionsButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        optionsButton.tintColor = .black
        
        addSubview(saveButton)
        saveButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        saveButton.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 12).isActive = true
    
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func shareTapped() {
        delegate?.shareTapped(cell: self)
    }
    
    @objc func didTapUsername() {
        delegate?.usernameTapped(cell: self)
    }
    
    @objc func commentTapped() {
        guard let viewModel = viewModel else { return }
        delegate?.commentTapped(post: viewModel.post)
    }
    
    @objc func didTapLike() {
        guard let post = viewModel?.post else { return }
        delegate?.likeTapped(post: post, cell: self) { [weak self] error, like in
            guard let currentLikes = Int(self?.likesLabel.text!.prefix(1) ?? "0") else { return }
            switch like {
            case .liked:
                self?.likesLabel.text = "\(currentLikes + 1) likes"
                self?.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
            case .unliked:
                self?.likesLabel.text = "\(currentLikes - 1) likes"
                self?.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
            }
        }
    }
    
    @objc func saveTapped() {
        guard let viewModel = viewModel else { return }
        delegate?.savePost(caption: self.captionLabel.text!, image: self.postImage.image!, uuid: viewModel.post.postId, completion: { [weak self] isSaved in
            let image = isSaved ? "ribbon" : "ribbon_filled"
            self?.saveButton.setImage(UIImage(named: image), for: .normal)
        })
    }
    
    
    @objc func optionsButtonPressed() {
        delegate?.showOptions(cell: self)
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        captionLabel.text = viewModel.caption
        profileImage.sd_setImage(with: URL(string: viewModel.post.profileImage))
        postImage.sd_setImage(with: URL(string: viewModel.post.imageUrl))
        usernameLabel.text = viewModel.username
        usernameButton.setTitle(viewModel.username, for: .normal)
        likesLabel.text = viewModel.likes
        postTimeLabel.text = viewModel.post.time.formatted(date: .abbreviated, time: .omitted)
        
        let likeImage = viewModel.post.isLiked ? "like_selected" : "like_unselected"
        likeButton.setImage(UIImage(named: likeImage), for: .normal)
        
        let saveImage = viewModel.post.isSaved ? "ribbon_filled" : "ribbon"
        saveButton.setImage(UIImage(named: saveImage), for: .normal)
    }
    
    func configureGestureRec() -> UITapGestureRecognizer {
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(didTapUsername))
        return gestureRecognizer
    }
    
}


