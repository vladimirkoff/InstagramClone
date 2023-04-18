//
//  MainTabController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 20.03.2023.
//

import UIKit
import FirebaseAuth
import YPImagePicker

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    private var user: User? {
        didSet {
            configureVC(with: user!)
        }
    }
    
    var scene: UIWindowScene
    
    //MARK: - Lifecycle
    
    init(scene: UIWindowScene) {
        self.scene = scene
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        checkIfLoggedIn()
        fetchUser()
    }
    
    //MARK: - API
    
    func checkIfLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController(scene: self.scene)
                controller.delegate = self
                controller.scene = self.scene
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } 
    }
    
    func fetchUser() {
        UserService.fetchUser { [weak self] user in
            self?.user = user
        }
    }
    
    //MARK: - Helpers
    
    func configureVC(with user: User) {
        self.delegate = self
        
        let feedVC = FeedController(user: user, postsType: .feed, scene: self.scene)
        let feed = templateNavController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootVC: feedVC)
        let search = templateNavController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootVC: SearchController())
        let post = templateNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, rootVC: PostController())
        let profile = ProfileController(user: user)
        let profileController = templateNavController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootVC: profile  )
        let notificationsVC = NotificationsController(user: user)
        let notifications = templateNavController(unselectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootVC: notificationsVC)
        
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
    
    open func didFinishChoosingMedia(picker: YPImagePicker) {
        picker.didFinishPicking { [weak self] items, cancelled in  // executes when we click "Finish"
            picker.dismiss(animated: true) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                let imageData = selectedImage.jpegData(compressionQuality: 0.7)
                
                let vc = UploadPostController()
                vc.imageData = imageData
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}



extension MainTabController: AuthDelegate {
    func authComplete() {
        fetchUser()
    }
}

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)  // returns the index of the selected vc
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false // does not save the post to the camera roll after posting
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true)
            
            didFinishChoosingMedia(picker: picker)
        }
        return true
    }
}


