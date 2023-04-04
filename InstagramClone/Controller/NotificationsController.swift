//
//  NotificationsController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 21.03.2023.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationsController: UICollectionViewController {
    //MARK: - Properties
    
    private var user: User
    
    private var notifications: [Notification]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
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
        configureUI()
        fetchNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - API
    
    func fetchNotifications() {
        var notificationsArray = [Notification]()
        NotificationService.fetchUserFollowed { notifications in
            notificationsArray += notifications
            NotificationService.fetchPostLiked { notifications in
                notificationsArray += notifications
                NotificationService.fetchCommentPost { notifications in
                    notificationsArray += notifications
                    self.notifications = notificationsArray
                }
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        collectionView.register(NotificationCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

//MARK: - UICollectionViewDelegate & DataSoruce

extension NotificationsController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as!
        NotificationCell
        cell.delegate = self
        if let notifications = notifications {
            cell.notificationType = notifications[indexPath.row].type
            cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
            if !notifications[indexPath.row].postImage.isEmpty && !notifications[indexPath.row].commentText.isEmpty {
                cell.viewModel?.notification.postImage = notifications[indexPath.row].postImage
                cell.viewModel?.notification.commentText = notifications[indexPath.row].commentText
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications?.count ?? 0
    }
}

//MARK: - NotificationCellDelegate

extension NotificationsController: NotificationCellDelegate {
    func goToPost(cell: NotificationCell) {
        guard let postId = cell.viewModel?.notification.postId else { return }
        PostService.fetchPost(postId: postId) { posts in
            let vc = FeedController(user: self.user, postsType: .single, scene: nil)
            vc.post = posts
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func checkIfFollowed(cell: NotificationCell, completion: @escaping (Bool) -> ()) {
        guard let uid = cell.viewModel?.notification.uid else { return }
        
        UserService.checkIfFollowed(uid: uid) { isFollowed in
            if isFollowed {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    func followButtonTapped(cell: NotificationCell, completion: @escaping(Bool) -> ()) {
        guard let uid = cell.viewModel?.notification.uid else { return }
        UserService.checkIfFollowed(uid: uid) { isFollowed in
            if isFollowed {
                UserService.unfollow(uid: uid) { error in
                    if let error = error {
                        print("Error unfollowing user from notification - \(error.localizedDescription) ")
                        return
                    }
                    completion(false)
                }
            } else {
                UserService.follow(uid: uid) { error in
                    if let error = error {
                        print("Error following user from notification - \(error.localizedDescription) ")
                        return
                    }
                    completion(true)
                }
            }
        }
    }
    
    func goToProfile(uid: String) {
        UserService.fetchUser(by: uid) { user in
            let vc = ProfileController(user: user)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension NotificationsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = NotificationViewModel(notification: notifications![indexPath.row])
        let width: CGFloat = view.frame.width
        let height: CGFloat = viewModel.size(width: width).height + 50
        return CGSize(width: width, height: height)
    }
}

