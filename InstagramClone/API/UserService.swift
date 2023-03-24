//
//  UserService.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 24.03.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

typealias FirestoreCompletion = (Error?) -> ()

struct UserService {  // fetching user information
    static func fetchUser(completion: @escaping(User) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, err in
            if let error = err {
                print("ERROR fetching user - \(error.localizedDescription)")
                return
            }
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    static func fetchUsers(completion:@escaping([User])->()){
        COLLECTION_USERS.getDocuments { snapshot, err in
            guard let snapshot = snapshot else { return }
       
            let users = snapshot.documents.map({User(dictionary: $0.data())})  // loops through the list of users
            completion(users)
        }
    }
    
    static func follow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) { err in
            if let error = err {
                print(error)
                return
            }
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
        }
    }
    static func unfollow() {
        
    }
}
