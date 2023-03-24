//
//  UserCellViewModel.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 24.03.2023.
//

import Foundation

struct UserCellViewModel {
    
    private let user: User
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var username: String? {
        return user.username
    }
    
    var fullName: String? {
        return  user.fullName
    }
    
    init(user: User) {
        self.user = user
    }
    
}
