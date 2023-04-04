//
//  AuthService.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 23.03.2023.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

struct AuthCreds {  
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage?
}

struct AuthService {
    static func registerUser(creds: AuthCreds, completion: @escaping(Error?) -> ()) {
        ImageUploader.uploadImage(image: creds.profileImage!) { imageUrl in
            Auth.auth().createUser(withEmail: creds.email, password: creds.password) { res, err in
                if let error = err {
                    completion(error)
                    return
                }
                guard let uid = res?.user.uid else { return }
                
                let data: [String: Any] = ["email": creds.email, "fullName": creds.fullname, "profileImageUrl": imageUrl, "uid": uid, "username": creds.username]
                
                Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
            }
        }
    }
}
