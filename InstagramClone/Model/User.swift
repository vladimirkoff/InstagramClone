//
//  User.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 24.03.2023.
//

import Foundation
import FirebaseAuth

struct User {
    let email: String
    let fullName: String
    let profileImageUrl: String
    let uid: String
    let username: String
    var isFollowed = false
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid ? true : false
    }
    
    
    init(dictionary: [String: Any]) {
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""

    }
}
