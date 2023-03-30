//
//  PostService.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 25.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

struct PostService {
    static func uploadPost(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(by: uid) { user in
            ImageUploader.uploadImage(image: image) { imageUrl in
                let uuid = UUID().uuidString
                let data: [String : Any] = ["caption" : caption, "timestamp" : Timestamp(date: Date()), "likes" : 0, "imageUrl" : imageUrl, "ownerUid" : uid, "postId": uuid, "username": user.username, "profileImage" : user.profileImageUrl]
                COLLECTION_POSTS.document(uuid).setData(data)
                COLLECTION_USERS.document(uid).collection("user-posts").document(uuid).setData(data, completion: completion)
            }
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> ()) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments {  snapshot, err in
            if let error = err {
                print("Error fetching posts - \(error.localizedDescription)")
                return
            }
            if let posts: [Post] = snapshot?.documents.map({Post(dictionary: $0.data())}) {
                completion(posts)
            }
        }
    }
    static func fetchPostsForUser(with uid: String, completion: @escaping([Post]) -> ()) {
        COLLECTION_USERS.document(uid).collection("user-posts").order(by: "timestamp", descending: true).getDocuments { snapshot, err in
            if let error = err {
                print("Error fetching posts - \(error.localizedDescription)")
                return
            }
            let posts = snapshot?.documents.map({Post(dictionary: $0.data())})
            if let posts = posts {
                completion(posts)
            }
        }
    }
    
    static func addToSaved(caption: String, image: UIImage, uuid: String, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_POSTS.document(uuid).getDocument { snapshot, err in
            guard let data = snapshot?.data() else { return }
            COLLECTION_USERS.document(uid).collection("user-saved").document(uuid).setData(data, completion: completion)
        }
    }
    
    static func checkIfSaved(postId: String, completion: @escaping(Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).collection("user-saved").document(postId).getDocument { snapshot, error in
            if let isSaved = snapshot?.exists {
                completion(isSaved)
            }
        }
    }
    
    static func fetchSavedPosts(completion: @escaping([Post]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).collection("user-saved").order(by: "timestamp", descending: true).getDocuments { snapshot, err in
            if let error = err {
                print("Error fetching posts - \(error.localizedDescription)")
                return
            }
            let posts = snapshot?.documents.map({Post(dictionary: $0.data())})
            if let posts = posts {
                completion(posts)
            }
        }
    }
    
    static func removeFromSaved(postId: String, completion: @escaping(Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).collection("user-saved").document(postId).delete(completion: completion)
    }
    
    static func likePost(postId: String, completion:@escaping(Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(postId).getDocument { snapshot, err in
            guard let snapshot = snapshot?.data() else { return }
            var data = snapshot
            var likes = snapshot["likes"] as! Int
            likes += 1
            data["likes"] = likes
            COLLECTION_POSTS.document(postId).updateData(["likes": likes])
            COLLECTION_POSTS.document(postId).collection("post-likes").document(uid).setData(["userId" : uid])
            COLLECTION_USERS.document(uid).collection("user-likes").document(postId).setData(data, completion: completion)
        }
    }
    
    static func unlikePost(postId: String, completion: @escaping(Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(postId).getDocument { snapshot, error in
            guard let snapshot = snapshot?.data() else { return }
            var likes = snapshot["likes"] as! Int
            likes += 1
            COLLECTION_POSTS.document(postId).updateData(["likes" : likes])
            COLLECTION_USERS.document(uid).collection("user-likes").document(postId).delete()
            COLLECTION_POSTS.document(postId).collection("post-likes").document(uid).delete(completion: completion)
        }
    }
    
    static func checkIfLiked(postId: String, completion: @escaping(Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(postId).getDocument { snapshot, error in
            guard let isLiked = snapshot?.exists else { return }

            completion(isLiked)
        }

    }
    
}
