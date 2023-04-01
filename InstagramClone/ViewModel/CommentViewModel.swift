//
//  CommentViewModel.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 01.04.2023.
//

import UIKit

struct CommentViewModel {
    
    let comment: Comment
    
    var text: String {
        return comment.text
    }
    
    
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    func size(width: CGFloat) -> CGSize {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = comment.text
        label.lineBreakMode = .byWordWrapping
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    
}
