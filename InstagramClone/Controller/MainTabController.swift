//
//  MainTabController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 20.03.2023.
//

import UIKit

class MainTabController: UITabBarController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureVC()
    }
    
    //MARK: - Helpers
    
    func configureVC() {
        
        
        
        let feed = templateNavController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootVC: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))
        let search = templateNavController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootVC: SearchController())
        let post = templateNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, rootVC: PostController())
        let profile = templateNavController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootVC: ProfileController())
        let notifications = templateNavController(unselectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootVC: NotificationsController())
        
        viewControllers = [ feed, search, post, notifications, profile ]
        
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
