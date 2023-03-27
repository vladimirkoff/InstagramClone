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
    
    var indexPath: Int?
    private var posts: [Post]?
    private var viewModel: PostViewModel?
    
    //MARK: - Lifecycle
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if let indexPath = indexPath {
            print("here")
            fetchSavedPosts()
        } else {
            fetchPosts(uid: uid)
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
    
    func getUserByUid(uid: String) {
        UserService.fetchUser(by: uid) { [weak self] user in
            self?.viewModel = PostViewModel(user: user)
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
        
        if let post = posts?[indexPath.row] {
            guard let uid = Auth.auth().currentUser?.uid else { return UICollectionViewCell() }
            getUserByUid(uid: uid)
            cell.postImage.sd_setImage(with: URL(string: post.imageUrl))
            cell.captionLabel.text = post.caption
            cell.usernameLabel.text = post.caption.isEmpty ? "" : viewModel?.username ?? ""
            cell.profileImage.sd_setImage(with: viewModel?.profileImageUrl)
            cell.usernameButton.setTitle(viewModel?.username ?? "", for: .normal)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SELECTED")
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
    
    func usernameTapped() {
        print("Username tapped")
    }
    
    func showOptions() {
//        if true {
//            actionSheet = ActionSheetLauncher()
//            self.actionSheet.delegate = self
//            actionSheet.show()
//        }
        print("Show options")
    }
    
    func savePost(caption: String, image: UIImage, uuid: String) {
        PostService.addToSaved(caption: caption, image: image, uuid: "sd") { error in
            if let error = error {
                print("Error saving post - \(error.localizedDescription)")
                return
            }
            print("Success!")
        }
    }
}

