//
//  ActionSheetLauncher.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 27.03.2023.
//


import UIKit
import FirebaseAuth

enum ActionType: String {
    case delete = "Delete post"
    case report = "Report post"
    case save = "Save post"
    case checkProfile = "Go to profile"
    case share = "Share post"
}

protocol ActionSheetDelegate: class {
    func goToProfile(user: User)
    func sharePostFromActionSheet(cell: PostCell)
}

private let reuseIdentifier = "ActionCell"

class ActionSheetLauncher: NSObject {
    
    //MARK: - Proeprties
    
    weak var delegate: ActionSheetDelegate?
    
    private let user: User
    private let post: Post
    private let tableView = UITableView()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.layer.cornerRadius = 12
        button.tintColor = .black
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(dismiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private var window: UIWindow?
    
    private var cell: PostCell?
    
    //MARK: - Lifecycle
    
    init(user: User, post: Post) {
        self.user = user
        self.post = post
        super.init()
    }
    
    
    
    //MARK: - Helpers
    
    func show(cell: PostCell) {
        configureTableView()
        self.cell = cell
        
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow }) else { return }
        self.window = window
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableView)
        let height = CGFloat(4 * 60) + 100
        tableView.frame = CGRect(x: 0 , y: window.frame.height, width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.blackView.alpha = 1
            self?.tableView.frame.origin.y -= height
        }
    }
    
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 5
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    //MARK: - Selectors
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 380
        }
    }
}

extension ActionSheetLauncher: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        if let uid = Auth.auth().currentUser?.uid {
            if uid == user.uid {
                let options: [ActionType] = [ .delete, .save, .checkProfile, .share ]
                cell.viewModel = ActionSheetViewModel(user: user, type: options[indexPath.row])
            } else {
                let options: [ActionType] = [ .report, .save, .checkProfile, .share ]
                cell.viewModel = ActionSheetViewModel(user: user, type: options[indexPath.row] )
            }
        }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if self.user.uid == Auth.auth().currentUser?.uid {
                PostService.deletePost(post: post, uid: user.uid)
            } else {
                print("Report")
            }
        case 1:
            PostService.checkIfSaved(postId: post.postId) { isSaved in
                if isSaved {
                    PostService.removeFromSaved(postId: self.post.postId) { error in
                        print("Unsaved")
                    }
                } else {
                    PostService.addToSaved(caption: self.post.caption, uuid: self.post.postId) { error in
                        print("Saved")
                    }
                }
            }
        case 2:
            let uid = post.uid
            UserService.fetchUser(by: uid) { user in
                self.dismiss()
                self.delegate?.goToProfile(user: user)
            }
        case 3:
            delegate?.sharePostFromActionSheet(cell: cell!)
        default:
            print("Error")
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
}
