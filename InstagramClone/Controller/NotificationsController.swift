//
//  NotificationsController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 21.03.2023.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationsController: UITableViewController {
    //MARK: - Properies
    
    private var user: User
    private var notifications: [Notification]? {
        didSet { tableView.reloadData() }
    }
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchFollowed()
        fetchPostLiked()
        fetchComment()
    }
    
    //MARK: - API
    
    
    func fetchFollowed() {
        NotificationService.fetchUserFollowed(uid: user.uid) { notifications in
            self.notifications = notifications
        }
    }
    
    func fetchPostLiked() {
        NotificationService.fetchPostLiked(uid: user.uid) { notifications in
            self.notifications = notifications
        }
    }
    
    func fetchComment() {
        NotificationService.fetchCommentPost(uid: user.uid) { notifications in
            self.notifications = notifications
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Comments"
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

extension NotificationsController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        if let notifications = notifications {
            print(notifications[indexPath.row].username)
        }
       return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}

