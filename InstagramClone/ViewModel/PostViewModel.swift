//
//  PostViewModel.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 25.03.2023.
//

import Foundation

struct PostViewModel {
    
    var post: Post
    
    var profileImageUrl: URL? {
        return URL(string: post.profileImage) 
    }
    
    var caption: String? {
        return post.caption
    }
    
    var likes: String {
        return  post.likes == 1 ? "\(post.likes) like"  : "\(post.likes) likes"
    }
    
    var username: String? {
        return post.username
    }
    
    init(post: Post) {
        self.post = post
    }
    
}
