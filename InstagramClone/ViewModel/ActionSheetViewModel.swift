//
//  ActionSheetViewModel.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 27.03.2023.
//

import Foundation

struct ActionSheetViewModel {
    
     var options: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        if true {
            results.append(.delete)
        } else {
            let followOption: ActionSheetOptions = .follow
            results.append(followOption)
        }
         results.append(.report)
        return results
    }
    
}

enum ActionSheetOptions {
    case follow
    case unfollow
    case report
    case delete
    
    var description: String {
        switch self {
        case .follow:
            return "Follow @"
        case .unfollow:
            return "Unfollow "
        case .report:
            return "Report tweet"
        case .delete:
            return "Delete tweet"
        }
    }
}
