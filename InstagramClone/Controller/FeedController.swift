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
    
    private var actionSheet: ActionSheetLauncher!
    private var posts: [Post]?
    private var viewModel: PostViewModel?
    private var user: User?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
        configureUI()
        collectionView.reloadData()
        
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
        navigationItem.title = "Instagram"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    //MARK: - API
    
    func fetchPosts() {
        PostService.fetchPosts { [weak self] posts in
            print("Get post")
            self?.posts = posts
            self?.collectionView.reloadData()
        }
    }
    
    func getUserByUid(uid: String) {
        print("GetUser")
        UserService.fetchUser(by: uid) { [weak self] user in
            self?.viewModel = PostViewModel(user: user)
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
            getUserByUid(uid: post.uid)
            cell.postImage.sd_setImage(with: URL(string: post.imageUrl))
            cell.post = self.posts![indexPath.row]
            cell.captionLabel.text = post.caption
            cell.usernameLabel.text = post.caption.isEmpty ? "" : viewModel?.username ?? ""
            cell.profileImage.sd_setImage(with: viewModel?.profileImageUrl)
            cell.usernameButton.setTitle(viewModel?.username ?? "ribbon", for: .normal)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SELECTED")
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
    
    func usernameTapped() {
        let vc = ProfileController(user: viewModel!.user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showOptions() {
        if true {
            actionSheet = ActionSheetLauncher()
            self.actionSheet.delegate = self
            actionSheet.show()
        }
    }
    
    func savePost(caption: String, image: UIImage, uuid: String) {
         PostService.checkIfSaved(postId: uuid, completion: { isSaved in
            if isSaved {
                PostService.removeFromSaved(postId: uuid) { error in
                    if let error = error {
                        print("Error unsaving post - \(error.localizedDescription)")
                        return
                    }
                }
            } else {
                PostService.addToSaved(caption: caption, image: image, uuid: uuid) { error in
                    if let error = error {
                        print("Error saving post - \(error.localizedDescription)")
                        return
                    }
                    print("Success!")
                }
            }
        })
    }
}
