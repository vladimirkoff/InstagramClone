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
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        navigationItem.title = "Comments"
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
}

extension NotificationsController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
       return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}

