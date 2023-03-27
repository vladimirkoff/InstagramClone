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
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data: [String : Any] = ["caption" : caption, "timestamp" : Timestamp(date: Date()), "likes" : 0, "imageUrl" : imageUrl, "ownerUid" : uid  ]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    static func uploadPostForUser(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data: [String : Any] = ["caption" : caption, "timestamp" : Timestamp(date: Date()), "likes" : 0, "imageUrl" : imageUrl, "ownerUid" : uid  ]
            
            COLLECTION_USER_POSTS.document(uid).collection("posts").addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> ()) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments {  snapshot, err in
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
    static func fetchPostsForUser(with uid: String, completion: @escaping([Post]) -> ()) {
        COLLECTION_USER_POSTS.document(uid).collection("posts").order(by: "timestamp", descending: true).getDocuments { snapshot, err in
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
    
    static func addToSaved(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data: [String : Any] = ["caption" : caption, "timestamp" : Timestamp(date: Date()), "likes" : 0, "imageUrl" : imageUrl, "ownerUid" : uid  ]
            
            COLLECTION_SAVED_POSTS.document(uid).collection("posts").addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchSavedPosts(completion: @escaping([Post]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        COLLECTION_SAVED_POSTS.document(uid).collection("posts").order(by: "timestamp", descending: true).getDocuments { snapshot, err in
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
}
