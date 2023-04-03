//
//  NotificationViewModel.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 01.04.2023.
//

import UIKit

struct NotificationViewModel {
    
    var notification: Notification
    
    func size(width: CGFloat) -> CGSize {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = notification.commentText
        label.lineBreakMode = .byWordWrapping
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}
