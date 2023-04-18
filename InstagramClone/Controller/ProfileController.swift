//
//  ProfileController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 21.03.2023.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    //MARK: - Properties
    
    private var currentUserUid: String?
    private var user: User
    private var posts: [Post]?
    private var viewModel: PostViewModel?
        
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentUserUid = Auth.auth().currentUser?.uid
        configureUI()
        fetchPosts(uid: user.uid)
        fetchUser()
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target: self, action: #selector(goToEdit))
    }
    
    //MARK: - API
    
    func fetchPosts(uid: String) {
        PostService.fetchPostsForUser(with: uid) { [weak self] posts in
            self?.posts = posts
            self?.collectionView.reloadData()
        }
    }
    
    func fetchUser() {
        UserService.fetchUser(by: user.uid) { user in
            self.user = user
        }
    }
    
   
    
    //MARK: - Helper
    
    func configureUI() {
        collectionView.backgroundColor = .white
        UserService.checkIfFollowed(uid: user.uid, completion: { [weak self] isFollowed in
            self?.user.isFollowed = isFollowed
            self?.collectionView.reloadData()
        })
        UserService.getNumberOfFollowers(uid: user.uid) { [weak self] num in
            self?.user.numberOfFollowers = num
            self?.collectionView.reloadData()
        }
        UserService.getNumberOfFollowing(uid: user.uid) { [weak self] num in
            self?.user.numberOfFollowing = num
            self?.collectionView.reloadData()
        }
        
        UserService.getNumberOfPosts(with: user.uid) { [weak self] num in
            self?.user.numberOfPosts = num
            self?.collectionView.reloadData()
        }
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier) // registerring header
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    //MARK: - Selectors
    
    @objc func handleRefresh() {
        collectionView.reloadData()
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    @objc func goToEdit() {
        let vc = EditProfileController(user: self.user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionView

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        if let posts = posts {
            cell.postImage.sd_setImage(with: URL(string: posts[indexPath.row].imageUrl))
        }
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
            header.viewModel = ProfileHeaderViewModel(user: user)
        header.delegate = self
        header.currentUserUid = currentUserUid
        header.numberOfFollowing = user.numberOfFollowing
        header.numberOfFollowers = user.numberOfFollowers
        header.numberOfPosts = user.numberOfPosts
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = FeedController(user: self.user, postsType: .profile, scene: nil)
        vc.navigationController?.navigationBar.barStyle = .default
       
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
    
}

//MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    
    
    func profileActionTapped(action: ProfileActions) {
        switch action {
        case .list:
            let vc = FeedController(user: self.user, postsType: .profile, scene: nil)
            vc.navigationController?.navigationBar.barStyle = .default
           
            navigationController?.pushViewController(vc, animated: true)

        case .posts:
            let vc = ProfileController(user: user)
            navigationController?.pushViewController(vc, animated: true)
        case .saved:
            let vc = SavedController(user: user)
            vc.navigationController?.navigationBar.isHidden = false
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func header(_ profileHeader: ProfileHeader, didTapActionButton forUser: User) {
        if user.isCurrentUser {
            let vc = EditProfileController(user: self.user)
            navigationController?.pushViewController(vc, animated: true)
        } else if user.isFollowed {

            UserService.unfollow(uid: user.uid) { [weak self] error in
                if let error = error {
                    print("Error following user - \(error.localizedDescription)")
                }
                guard let uid = Auth.auth().currentUser?.uid else { return }
                UserService.fetchUser(by: uid) { user in
                    NotificationService.unfollowed(notifOwner: user, user: forUser) { error in
                        
                    }
                }
                
                self?.user.isFollowed = false
                self?.user.numberOfFollowers -= 1
                self?.collectionView.reloadData()
            }
        } else {
            UserService.follow(uid: user.uid) { [weak self] error  in
                if let error = error {
                    print("Error following user - \(error.localizedDescription)")
                }
                
                // the notification
                guard let uid = Auth.auth().currentUser?.uid else { return }
                UserService.fetchUser(by: uid) { ownerUser in
                    guard let user = self?.user else { return }
                    NotificationService.userFollowed(notifOwner: ownerUser, user: user) { error in
                        self?.user.isFollowed = true
                        self?.user.numberOfFollowers += 1
                        self?.collectionView.reloadData()
                    }
                }
            }
        }
    }
}
