//
//  AuthViewModel.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 22.03.2023.
//

import UIKit

protocol FormViewModel {
    func updateForm()
}

protocol AuthViewModel {
    var formIsValid: Bool { get }
    var buttonColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}

struct LoginViewModel: AuthViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonColor: UIColor {
        return formIsValid ? .black : .purple.withAlphaComponent(0.7)
    }
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.7)
    }
    var buttonIsEnabled: Bool {
        return formIsValid ? true : false
    }
}

struct RegistrationViewModel: AuthViewModel {
    var email: String?
    var password: String?
    var username: String?
    var fullname: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
        && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var buttonColor: UIColor {
        return formIsValid ? .black : .purple.withAlphaComponent(0.7)
    }
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.7)
    }
    var buttonIsEnabled: Bool {
        return formIsValid ? true : false
    }
}
