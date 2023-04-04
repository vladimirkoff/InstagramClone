//
//  ActionSheetViewModel.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 27.03.2023.
//

import UIKit

struct ActionSheetViewModel {
    
    let user: User
    
    let type: ActionType
    
    var title: String {
        return type.rawValue
    }
    
    var image: UIImage {
        switch type {
            
        case .delete:
            return UIImage(systemName: "trash")!
        case .report:
            return UIImage(systemName: "externaldrive.fill.trianglebadge.exclamationmark")!
        case .save:
            return UIImage(named: "ribbon")!
        case .checkProfile:
            return UIImage(named: "profile_selected")!
        }
    }
    
}
