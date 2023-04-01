//
//  NotificationService.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 01.04.2023.
//

import Foundation
import FirebaseAuth

struct NotificationService {
    static func userFollowed(user: User, ownUser: User, completion: @escaping(Error?) -> ()) {
        let data: [String: Any] = ["username" : ownUser.username, "profileUrl" : ownUser.profileImageUrl]
        COLLECTION_NOTIFICATIONS.document(user.uid).collection("notifications-followed").addDocument(data: data, completion: completion)
    }
    
    static func fetchUserFollowed(uid: String, completion: @escaping([Notification]) -> ()) {
        COLLECTION_NOTIFICATIONS.document(uid).collection("notifications-followed").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching followed notifications - \(error.localizedDescription)")
                return
            }
            
            if  let notifications = snapshot?.documents.map({
                let username = $0.data()["username"] as? String ?? ""
                let profileUrl = $0.data()["profileUrl"] as? String ?? ""
                let notification = Notification(username: username, profileUrl: profileUrl)
                return notification
            }) {
                completion(notifications)
            }
        }
    }
    
    static func postLiked(user: User, ownUser: User, post: Post, completion: @escaping(Error?) -> ()) {
        let data: [String : Any] = ["username" : ownUser.username, "postId" : post.postId, "profileUrl" : ownUser.profileImageUrl, "postImage"  : post.imageUrl ]
        COLLECTION_NOTIFICATIONS.document(user.uid).collection("notifications-postLiked").addDocument(data: data, completion: completion)
    }
    
    static func fetchPostLiked(uid: String, completion: @escaping([Notification]) -> ()) {
        COLLECTION_NOTIFICATIONS.document(uid).collection("notifications-postLiked").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching postLiked notifications - \(error.localizedDescription)")
                return
            }
            
            if let notifications = snapshot?.documents.map({
                let username = $0.data()["username"] as? String ?? ""
                let profileUrl = $0.data()["profileUrl"] as? String ?? ""
                var notification = Notification(username: username, profileUrl: profileUrl)
                notification.postId = $0.data()["postId"] as? String ?? ""
                notification.postImage = $0.data()["postImage"] as? String ?? ""
                return notification
            }) {
                completion(notifications)
            }
        }
    }
    
    static func commentedPost(user: User, ownUser: User, post: Post, comment: Comment, completion: @escaping(Error?) -> ()) {
        let data: [String : Any] = ["username" : ownUser.username, "postId" : post.postId, "profileUrl" : ownUser.profileImageUrl, "commentText" : comment.text, "postImageUrl" : post.imageUrl]
        
        COLLECTION_NOTIFICATIONS.document(user.uid).collection("notifications-commented").addDocument(data: data, completion: completion)
    }
    
    static func fetchCommentPost(uid: String, completion: @escaping([Notification]) -> ()) {
        COLLECTION_NOTIFICATIONS.document(uid).collection("notifications-commented").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching postLiked notifications - \(error.localizedDescription)")
                return
            }
            
            if let notifications = snapshot?.documents.map({
                let username = $0.data()["username"] as? String ?? ""
                let profileUrl = $0.data()["profileUrl"] as? String ?? ""
                var notification = Notification(username: username, profileUrl: profileUrl)
                notification.postId = $0.data()["postId"] as? String ?? ""
                notification.postImage = $0.data()["postImage"] as? String ?? ""
                notification.commentText = $0.data()["commentText"] as? String ?? ""
                return notification
            }) {
                completion(notifications)
            }
        }
    }
}
