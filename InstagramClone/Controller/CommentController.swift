//
//  CommentController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 30.03.2023.
//

import UIKit
import FirebaseAuth

private var reuseIdentifier = "CommentCell"

class CommentController: UICollectionViewController {
    
    //MARK: - Properties
    
   lazy private var commentInputView: CommentTextView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentTextView(frame: frame )
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    var user: User?
    
    var post: Post?
    
    private var commentUsers: [User]? {
        didSet { collectionView.reloadData()}
    }
    
    private var comments: [Comment]? {
        didSet {
            collectionView.reloadData()
            }
        }

    
    
    override var inputAccessoryView: UIView? {
        get {
            return commentInputView
        }
    }
    
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(by: uid) { user in
            self.user = user
        }
    }
    
    lazy private var underline: UIView = {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = .lightGray
         return view
     }()
    
    //MARK: - Lifecycle
    
    init(post: Post) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        fetchComments()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.title = "Comments"
        configureUI()
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        view.addSubview(commentInputView)
        commentInputView.delegate = self
        commentInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 8).isActive = true
        commentInputView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        commentInputView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    
    }
    
    //MARK: - API
    
    func fetchComments() {
        guard let post = post else { return }
        PostService.fetchComments(postId: post.postId) { comments in
            self.comments = comments
        }
    }
    
    //MARK: - Selectors
    
    @objc func cancelPressed() {
        self.dismiss(animated: true)
    }
}

extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        if let comments = comments {
            cell.delegate = self
            cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
}

extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
}

extension CommentController: CommentTextViewDelegate {
    func postComment(text: String) {
        guard let user = user else { return }
        
        let comment = Comment(text: text, uid: user.uid, username: user.username, profileUrl: user.profileImageUrl, timeStamp: Date())
        PostService.uploadComment(post: post!, comment: comment) { error in
            self.fetchComments()
        }
    }
}

extension CommentController: CommentCellDelegate {
    func goToProfile(uid: String) {
        UserService.fetchUser(by: uid) { user in
            print("Here")
            let vc = ProfileController(user: user)
            vc.tabBarController?.tabBar.isHidden = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

