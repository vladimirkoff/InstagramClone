//
//  PostViewModel.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 25.03.2023.
//

import Foundation

struct PostViewModel {
    
    private let user: User
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var username: String? {
        return user.username
    }
    
    var upperUsername: String? {
        return user.username
    }

    init(user: User) {
        self.user = user
    }
    
}
