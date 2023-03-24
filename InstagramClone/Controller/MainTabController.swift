//
//  MainTabController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 20.03.2023.
//

import UIKit
import FirebaseAuth

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    private var user: User? {
        didSet {
            configureVC(with: user!)
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        checkIfLoggedIn()
        fetchUser()
    }
    
    //MARK: - API
    
    func checkIfLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                
                self.present(nav, animated: true, completion: nil)
            }
            
        }
    }
    
    func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
        }
    }
    
    //MARK: - Helpers
    
    func configureVC(with user: User) {
        
        
        let feed = templateNavController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootVC: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))
        let search = templateNavController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootVC: SearchController())
        let post = templateNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, rootVC: PostController())
        let profile = ProfileController(user: user)
        let profileController = templateNavController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootVC: profile  )
        let notifications = templateNavController(unselectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootVC: NotificationsController())
        
        viewControllers = [ feed, search, post, notifications, profileController ]
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        
    }
    
    func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootVC: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootVC)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        nav.navigationBar.backgroundColor = .white
        nav.navigationBar.barStyle = .default
        return nav
    }
    
}

extension MainTabController: AuthDelegate {
    func authComplete() {
        fetchUser()
        self.dismiss(animated: true)
    }
}
