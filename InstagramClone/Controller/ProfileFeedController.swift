//
//  ProfileFeed.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 27.03.2023.
//


import UIKit
import FirebaseAuth
import SDWebImage

private let reuseIdentifier = "ProfilePostCell"

class ProfileFeedController: UICollectionViewController {
    

    private var posts: [Post]?
    private var viewModel: PostViewModel?
    
    var profile: Bool?
    
    //MARK: - Lifecycle
    

    override func viewWillAppear(_ animated: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if let profile = profile {
            if profile {
                fetchPosts(uid: uid)
            } else {
                fetchSavedPosts()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        collectionView.reloadData()
        
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
        navigationItem.title = "Posts"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    //MARK: - API
    
    func fetchPosts(uid: String) {
        PostService.fetchPostsForUser(with: uid) { [weak self] posts in
            self?.posts = posts
            self?.collectionView.reloadData()
        }
    }
    
    func fetchSavedPosts() {
        PostService.fetchSavedPosts { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
    func fetchUser(uid: String, completion: @escaping(User) -> ()) {
        UserService.fetchUser(by: uid) { user in
            completion(user)
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension ProfileFeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        cell.delegate = self
        if let posts = self.posts {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        return cell
    }
   
    //MARK: - Selectors
    
    @objc func handleRefresh() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        fetchPosts(uid: uid)
        self.collectionView.refreshControl?.endRefreshing()
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileFeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 110
        return CGSize(width: width, height: height)
    }
}

extension ProfileFeedController: PostCellDelegate {
    func commentTapped(post: Post) {
        
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
//        if true {
//            actionSheet = ActionSheetLauncher()
//            self.actionSheet.delegate = self
//            actionSheet.show()
//        }
        print("Show options")
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

