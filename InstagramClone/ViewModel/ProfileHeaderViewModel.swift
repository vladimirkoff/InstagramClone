//
//  ProfileHeaderViewModel.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 24.03.2023.
//

import Foundation
import FirebaseAuth
import UIKit

struct ProfileHeaderViewModel {
    
    let user: User
    var fullName: String {
        return user.fullName
    }
    var profileImageUrl: String {
        return user.profileImageUrl
    }
    
    var followButtonText: String {
        if user.uid == Auth.auth().currentUser?.uid {
            return  "Edit profile"
        }
        
        return user.isFollowed ? "Unfollow" : "Follow"

    }
    
    var followButtonColor: UIColor {
        return user.isFollowed ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return user.isFollowed ? .black : .white
    }
    
    init(user: User) {
        self.user = user
    }
    
}
