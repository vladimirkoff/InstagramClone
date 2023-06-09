//
//  SavedController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 27.03.2023.
//

import UIKit

fileprivate let reuseIdentifier = "SavedCell"

class SavedController: UICollectionViewController {
    //MARK: - Properties
    
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
        tabBarController?.tabBar.isHidden = false
        fetchPosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }
    
    //MARK: - API
    
    func fetchPosts() {
        PostService.fetchSavedPosts { [weak self] posts in
            self?.posts = posts
            self?.collectionView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "Saved posts"
        navigationController?.navigationBar.backgroundColor = .red
        view.backgroundColor = .purple
        
        
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    //MARK: - Selectors
    
    @objc func handleRefresh() {
        collectionView.reloadData()
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UICollectionView

extension SavedController {
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = FeedController(user: user, postsType: .saved, scene: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SavedController: UICollectionViewDelegateFlowLayout {
    
    
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
}



