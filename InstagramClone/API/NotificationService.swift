//
//  NotificationService.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 01.04.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct NotificationService {
    static func userFollowed(notifOwner: User, user: User,  completion: @escaping(Error?) -> ()) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        let data: [String: Any] = ["username" : notifOwner.username, "profileUrl" : notifOwner.profileImageUrl, "timestamp" : Timestamp(date: Date()), "uid": notifOwner.uid]
        COLLECTION_NOTIFICATIONS.document(user.uid).collection("notifications-followed").addDocument(data: data, completion: completion)
    }
    
    static func fetchUserFollowed(completion: @escaping([Notification]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_NOTIFICATIONS.document(uid).collection("notifications-followed").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching followed notifications - \(error.localizedDescription)")
                return
            }
            
            if  let notifications = snapshot?.documents.map({
                let username = $0.data()["username"] as? String ?? ""
                let profileUrl = $0.data()["profileUrl"] as? String ?? ""
                let uid = $0.data()["uid"] as? String ?? ""
                var notification = Notification(username: username, profileUrl: profileUrl, uid: uid)
                notification.type = NotificationType.follow
                return notification
            }) {
                completion(notifications)
            }
        }
    }
    
    static func postLiked(user: User, post: Post, completion: @escaping(Error?) -> ()) {
        guard user.uid != post.uid else { return }
        let data: [String : Any] = ["username" : user.username, "postId" : post.postId, "profileUrl" : user.profileImageUrl, "postImage"  : post.imageUrl, "timestamp" : Timestamp(date: Date()), "uid": user.uid]
        
        COLLECTION_NOTIFICATIONS.document(post.uid).collection("notifications-postLiked").addDocument(data: data, completion: completion)
    }
    
    static func fetchPostLiked(completion: @escaping([Notification]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_NOTIFICATIONS.document(uid).collection("notifications-postLiked").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching postLiked notifications - \(error.localizedDescription)")
                return
            }
            
            if let notifications = snapshot?.documents.map({
                let username = $0.data()["username"] as? String ?? ""
                let profileUrl = $0.data()["profileUrl"] as? String ?? ""
                let uid = $0.data()["uid"] as? String ?? ""
                var notification = Notification(username: username, profileUrl: profileUrl, uid: uid)
                notification.postId = $0.data()["postId"] as? String ?? ""
                notification.postImage = $0.data()["postImage"] as? String ?? ""
                notification.type = NotificationType.likePost
                return notification
            }) {
                completion(notifications)
            }
        }
    }
    
    static func commentedPost(user: User, post: Post, comment: Comment, completion: @escaping(Error?) -> ()) {
        guard user.uid != post.uid else { return }
        
        let data: [String : Any] = ["username" : user.username, "postId" : post.postId, "profileUrl" : user.profileImageUrl, "commentText" : comment.text, "postImageUrl" : post.imageUrl, "timestamp" : Timestamp(date: Date()), "uid": user.uid]
        
        COLLECTION_NOTIFICATIONS.document(post.uid).collection("notifications-commented").addDocument(data: data, completion: completion)
    }
    
    static func fetchCommentPost(completion: @escaping([Notification]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_NOTIFICATIONS.document(uid).collection("notifications-commented").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching postLiked notifications - \(error.localizedDescription)")
                return
            }
            
            if let notifications = snapshot?.documents.map({
                let username = $0.data()["username"] as? String ?? ""
                let profileUrl = $0.data()["profileUrl"] as? String ?? ""
                let uid = $0.data()["uid"] as? String ?? ""
                var notification = Notification(username: username, profileUrl: profileUrl, uid: uid)
                notification.postId = $0.data()["postId"] as? String ?? ""
                notification.postImage = $0.data()["postImageUrl"] as? String ?? ""
                notification.commentText = $0.data()["commentText"] as? String ?? ""
                notification.type = NotificationType.comment
                return notification
            }) {
                completion(notifications)
            }
        }
    }
    
    static func postUnliked(user: User, post: Post, completion: @escaping(Error?) -> ()) {
        guard user.uid != post.uid else { return }
        
        COLLECTION_NOTIFICATIONS.document(post.uid).collection("notifications-postLiked").getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            docs.forEach { snapshot in
                if snapshot.data()["postId"] as? String ?? "" == post.postId {
                    COLLECTION_NOTIFICATIONS.document(post.uid).collection("notifications-postLiked").document(snapshot.documentID).delete()
                }
            }
        }
    }
    
    static func unfollowed(notifOwner: User, user: User,  completion: @escaping(Error?) -> ()) {
        print(notifOwner.uid)
        print(user.uid)
        COLLECTION_NOTIFICATIONS.document(user.uid).collection("notifications-followed").getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            docs.forEach { snapshot in
                if snapshot["uid"] as? String ?? "" == notifOwner.uid {
                    COLLECTION_NOTIFICATIONS.document(user.uid).collection("notifications-followed").document(snapshot.documentID).delete()
                }
            }
        }
    }
    
//    static func commentDeleted(user: User, post: Post, completion: @escaping(Error?) -> ()) {
//        guard user.uid != post.uid else { return }
//
//        COLLECTION_NOTIFICATIONS.document(post.uid).collection("notifications-postLiked").getDocuments { snapshot, error in
//            guard let docs = snapshot?.documents else { return }
//            docs.forEach { snapshot in
//                if snapshot.data()["postId"] as? String ?? "" == post.postId {
//                    COLLECTION_NOTIFICATIONS.document(post.uid).collection("notifications-postLiked").document(snapshot.documentID).delete()
//                }
//            }
//        }
//    }
}
