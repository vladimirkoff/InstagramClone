//
//  CommentViewModel.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 01.04.2023.
//

import Foundation

struct CommentViewModel {
    
    let comment: Comment
    
    var text: String {
        return comment.text
    }
    
    
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    
    
}
