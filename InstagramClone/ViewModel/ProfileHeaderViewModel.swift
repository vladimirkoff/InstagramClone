//
//  ProfileHeaderViewModel.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 24.03.2023.
//

import Foundation

struct ProfileHeaderViewModel {
    
    let user: User
    var fullName: String {
        return user.fullName
    }
    var profileImageUrl: String {
        return user.profileImageUrl
    }
    
    init(user: User) {
        self.user = user
    }
    
}
