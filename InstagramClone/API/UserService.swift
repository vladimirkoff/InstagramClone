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
    static func unfollow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete {  error in
            if let error = error {
                print("Error unfollowing user = \(error.localizedDescription)")
                return
            }
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion
            )}
    }
    static func checkIfFollowed(uid: String, completion: @escaping(Bool) -> ()) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).getDocument { snapshot, error in
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
    }
    
    static func getNumberOfFollowers(uid: String, completion: @escaping(Int) -> ()) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, error in
            guard let num = snapshot?.documents.count else { return }
            completion(num)
        }
    }
    
    static func getNumberOfFollowing(uid: String, completion: @escaping(Int) -> ()) {
        COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { snapshot, error in
            guard let num = snapshot?.documents.count else { return }
            completion(num)
        }
    }
    static func fetchUser(by uid: String, completion: @escaping(User) -> ()) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, err in
            guard let dictionary: [String: Any] = snapshot?.data() else { return }
            if let error = err {
                print("Error fetching user - \(error)")
                return
            }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    static func getNumberOfPosts(with uid: String, completion: @escaping(Int) -> ()) {
        COLLECTION_USER_POSTS.document(uid).collection("posts").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            completion(snapshot.count)
        }
    }
}

