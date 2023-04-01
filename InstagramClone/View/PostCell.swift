//
//  PostCell.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 21.03.2023.
//

import UIKit
import SDWebImage

protocol PostCellDelegate: class {
    func showOptions()
    func savePost(caption: String, image: UIImage, uuid: String, completion: @escaping(Bool) -> ())  // saving post
    func usernameTapped(cell: PostCell)
    func likeTapped(post: Post, cell: PostCell)
    func commentTapped(post: Post)
    func shareTapped(post: Post)
}

class PostCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var viewModel: PostViewModel? {
        didSet {
            configure()
        }
    }
    
    
    
    weak var delegate: PostCellDelegate?
    
    
    var profileImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemPurple
        iv.isUserInteractionEnabled = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
     lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        return button
    }()
    
     var postImage: UIImageView = {
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
        label.text = "1 like"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
     var captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2 days ago"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    var usernameLabel: UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       label.font = UIFont.boldSystemFont(ofSize: 14)
       return label
   }()

    lazy private var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "dots"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(optionsButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 10, height: 2)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ribbon"), for: .normal)
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
        postTimeLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 8).isActive = true
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
        
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(didTapUsername))
        profileImage.addGestureRecognizer(gestureRecognizer)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func shareTapped() {
        guard let viewModel = viewModel else { return }
        delegate?.shareTapped(post: viewModel.post)
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
        delegate?.likeTapped(post: post, cell: self)
    }
    
    @objc func saveTapped() {
        delegate?.savePost(caption: self.captionLabel.text!, image: self.postImage.image!, uuid: viewModel!.post.postId, completion: { isSaved in
            print(isSaved)
            let image = isSaved ? "ribbon" : "ribbon_filled"
            self.saveButton.setImage(UIImage(named: image), for: .normal)
        })
    }
    
    
    @objc func optionsButtonPressed() {
        delegate?.showOptions()
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
        
        let likeImage = viewModel.post.isLiked ? "like_selected" : "like_unselected"
        likeButton.setImage(UIImage(named: likeImage), for: .normal)
        
        let saveImage = viewModel.post.isSaved ? "ribbon_filled" : "ribbon"
        saveButton.setImage(UIImage(named: saveImage), for: .normal)
    }
    
   
}


