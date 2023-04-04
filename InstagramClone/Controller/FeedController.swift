//
//  FeedController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 21.03.2023.
//

import UIKit
import FirebaseAuth
import SDWebImage

private let reuseIdentifier = "Cell"

enum PostsType {
    case feed
    case profile
    case saved
    case single
}

class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var user: User
    
    var post: [Post]?
    
    let postsType: PostsType
    
    private var actionSheet: ActionSheetLauncher?
        
    private var posts: [Post]? {
        didSet {
            collectionView.reloadData()
        }
    }
    

    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false

        switch postsType {
            
        case .feed:
            fetchPosts()
        case .profile:
            fetchPostsForUser(withUid: user.uid)
        case .saved:
            fetchSavedPosts()
        case .single:
            self.posts = self.post
        }
    }
    
    init(user: User, postsType: PostsType) {
        self.user = user
        self.postsType = postsType
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
        navigationItem.title = "Instagram"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    //MARK: - API
    
    func fetchUser(uid: String, completion: @escaping(User) -> ()) {
        UserService.fetchUser(by: uid) { user in
            completion(user)
        }
    }
    
    func checkIfSaved() {
        self.posts?.forEach({ post in
            PostService.checkIfSaved(postId: post.postId) { isSaved in
                if let index = self.posts?.firstIndex(where: {$0.postId == post.postId}) {
                    self.posts![index].isSaved = isSaved
                }
            }
        })
    }
    
    func checkIfLiked() {
        self.posts!.forEach { post in
            PostService.checkIfLiked(postId: post.postId) { isLiked in
                if let index = self.posts?.firstIndex(where: {$0.postId == post.postId}) {
                    self.posts![index].isLiked = isLiked
                }
            }
        }
    }
    
    func fetchPosts() {
        PostService.fetchPosts { [weak self] posts in
            self?.posts = posts
            self?.checkIfLiked()
            self?.checkIfSaved()
        }
    }
    
    func fetchPostsForUser(withUid uid: String) {
        PostService.fetchPostsForUser(with: uid) { posts in
            self.posts = posts
            self.checkIfLiked()
            self.checkIfSaved()
        }
    }
    
    func fetchSavedPosts() {
        PostService.fetchSavedPosts { posts in
            self.posts = posts
            self.checkIfLiked()
            self.checkIfSaved()
        }
    }
    
}


//MARK: - UICollectionViewDataSource

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        cell.delegate = self
        if let post = posts?[indexPath.row] {
            cell.viewModel = PostViewModel(post: post)
        }
        return cell
    }
    
    //MARK: - Selectors
    
    @objc func logOut() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        } catch {
            print("Error logging out - \(error.localizedDescription)")
        }
    }
    
    @objc func handleRefresh() {
        switch postsType {
            
        case .feed:
            fetchPosts()
        case .profile:
            fetchPostsForUser(withUid: user.uid)
        case .saved:
            fetchSavedPosts()
        case .single:
            posts = post
        }
        self.collectionView.refreshControl?.endRefreshing()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 110
        return CGSize(width: width, height: height)
    }
}

//MARK: - PostCellDelegate

extension FeedController: PostCellDelegate {
    
    func shareTapped(post: Post) {
        
    }

    func commentTapped(post: Post) {
        let vc = CommentController(post: post)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func likeTapped(post: Post, cell: PostCell, completion: @escaping (Error?, LikedUnliked) -> ()) {
        PostService.checkIfLiked(postId: post.postId) { isLiked in
            if isLiked {
                cell.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
                PostService.unlikePost(postId: post.postId) { error in
                    completion(error, .unliked)
                    NotificationService.postUnliked(user: self.user, post: post) { error in
                        
                    }
                }
            } else {
                cell.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
                UserService.fetchUser(by: post.uid) { user in
                    NotificationService.postLiked(user: self.user, post: post) { error in
                        PostService.likePost(postId: post.postId ) { err in
                            completion(error, .liked)
                        }
                    }
                }
            }
        }
    }
    
    func usernameTapped(cell: PostCell) {
        guard let uid = cell.viewModel?.post.uid else { return }
        fetchUser(uid: uid ) { [weak self] user in
                let vc = ProfileController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showOptions(cell: PostCell) {
        UserService.fetchUser(by: cell.viewModel!.post.uid) { user in
            self.actionSheet = ActionSheetLauncher(user: user, post: cell.viewModel!.post)
            self.actionSheet?.delegate = self
            self.actionSheet!.show()
        }
    }
    
    func savePost(caption: String, image: UIImage, uuid: String, completion: @escaping(Bool) -> ()) {
        PostService.checkIfSaved(postId: uuid) { isSaved in
            completion(isSaved)
            if isSaved {
                PostService.removeFromSaved(postId: uuid) { error in
                    print("Unsaved")
                }
            } else {
                PostService.addToSaved(caption: caption, uuid: uuid) { error in
                    print("Saved")
                }
            }
        }
    }
}

//MARK: - ActionSheetDelegate

extension FeedController: ActionSheetDelegate {
    func goToProfile(user: User) {
        let vc = ProfileController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}
