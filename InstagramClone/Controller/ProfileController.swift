//
//  ProfileController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 21.03.2023.
//

import UIKit

fileprivate let reuseIdentifier = "ProfileCell"
fileprivate let headerIdentifier = "ProfileHeader"



class ProfileController: UICollectionViewController {
    //MARK: - Properties
    
    private var user: User
        
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        configureUI()
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
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier) // registerring header
    }
}

//MARK: - UICollectionView

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
            header.viewModel = ProfileHeaderViewModel(user: user)
        header.delegate = self
        header.numberOfFollowing = user.numberOfFollowing
        header.numberOfFollowers = user.numberOfFollowers
        return header
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
    func header(_ profileHeader: ProfileHeader, didTapActionButton forUser: User) {
        if user.isCurrentUser {
            print("Edit profile")
        } else if user.isFollowed {
            UserService.unfollow(uid: user.uid) { [weak self] error in
                if let error = error {
                    print("Error following user - \(error.localizedDescription)")
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
                self?.user.isFollowed = true
                self?.user.numberOfFollowers += 1
                self?.collectionView.reloadData()
            }
        }
    }
    
}
