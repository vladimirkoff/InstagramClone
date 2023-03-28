//
//  Post.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 25.03.2023.
//

import Foundation

struct Post {
    let imageUrl: String
    let uid: String
    var likes: Int
//    var time: Date
    var caption: String
    var postId: String
    var username: String
    var profileImage: String
    var isSaved = false
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.uid = dictionary["ownerUid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
//        self.time = dictionary["timestamp"] as? Date ?? Date()
        self.caption = dictionary["caption"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImage = dictionary["profileImage"] as? String ?? ""
    }
}
