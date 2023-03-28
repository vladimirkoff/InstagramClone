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
    
    private var posts: [Post]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var viewModel: PostViewModel?
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func configureViewModel(uid: String, postId: String) {
        PostService.checkIfSaved(postId: postId) { [weak self] isSaved in
            UserService.fetchUser(by: uid) { user in
                self?.viewModel = PostViewModel(user: user)
                self?.viewModel?.isSaved = isSaved
            }
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
        if let posts = posts {
            configureViewModel(uid: posts[indexPath.row].uid, postId: posts[indexPath.row].postId)
            if let viewModel = viewModel {
                cell.postImage.sd_setImage(with: URL(string: posts[indexPath.row].imageUrl))
                cell.post = posts[indexPath.row]
                cell.captionLabel.text = posts[indexPath.row].caption
                cell.usernameLabel.text = posts[indexPath.row].caption.isEmpty ? "" : posts[indexPath.row].username
                cell.profileImage.sd_setImage(with: URL(string: posts[indexPath.row].profileImage) )
                cell.usernameButton.setTitle(posts[indexPath.row].username, for: .normal)
//                let image = viewModel.isSaved ? UIImage(named: "ribbon_filled") : UIImage(named: "ribbon")
//                cell.saveButton.setImage(image, for: .normal)
            }
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
    
    func likeTapped() {
        print("Liked")
    }
    
    
    func usernameTapped() {
//        let vc = ProfileController(user: viewModel!.user)
//        navigationController?.pushViewController(vc, animated: true)
        print("Go to profile")
    }
    
    func showOptions() {
        if true {
            actionSheet = ActionSheetLauncher()
            self.actionSheet.delegate = self
            actionSheet.show()
        }
    }
    
    func savePost(caption: String, image: UIImage, uuid: String, completion: @escaping(Bool) -> ()) {
        var saved = false
        PostService.checkIfSaved(postId: uuid, completion: { isSaved in
            print(isSaved)
            if isSaved {
                saved = true
                PostService.removeFromSaved(postId: uuid) { error in
                    if let error = error {
                        print("Error unsaving post - \(error.localizedDescription)")
                        return
                    }
                    completion(saved)
                }
                return
            } else {
                saved = false
                PostService.addToSaved(caption: caption, image: image, uuid: uuid) { error in
                    if let error = error {
                        print("Error saving post - \(error.localizedDescription)")
                        return
                    }
                    completion(saved)
                }
                
            }
        })
    }
}
