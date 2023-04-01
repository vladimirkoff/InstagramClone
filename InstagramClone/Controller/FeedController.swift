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

class FeedController: UICollectionViewController, ActionSheetDelegate {
    func didSelect(option: ActionSheetOptions) {
        print("Tapped")
    }
    
    private var isLiked: Bool?

    private var actionSheet: ActionSheetLauncher!
    
    private var posts: [Post]? {
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        fetchPosts()
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
        navigationItem.title = "Instagram"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    //MARK: - API
    
    func fetchPosts() {
        PostService.fetchPosts { [weak self] posts in
            self?.posts = posts
        }
    }
    
    func checkIfLiked(postId: String) {
       guard let uid = Auth.auth().currentUser?.uid else { return }
        PostService.checkIfLiked(postId: postId) { isLiked in
            self.isLiked = isLiked
        }
    }
    
    func fetchUser(uid: String, completion: @escaping(User) -> ()) {
        UserService.fetchUser(by: uid) { user in
            completion(user)
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
        if var post = posts?[indexPath.row] {
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
        fetchPosts()
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

extension FeedController: PostCellDelegate {
    
    func commentTapped(post: Post) {
        let vc = CommentController(post: post)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func likeTapped(post: Post, cell: PostCell) {
        guard let postId = cell.viewModel?.post.postId else { return }
        PostService.checkIfLiked(postId: postId) { isLiked in
            if isLiked {
                PostService.unlikePost(postId: postId) { error in
                    print("Completed unliking")
                }
            } else {
                PostService.likePost(postId: postId ) { err in
                    print("Completed liking")
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
    
    func showOptions() {
        if true {
            actionSheet = ActionSheetLauncher()
            self.actionSheet.delegate = self
            actionSheet.show()
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
                PostService.addToSaved(caption: caption, image: image, uuid: uuid) { error in
                    print("Saved")
                }
            }
        }
    }
}
