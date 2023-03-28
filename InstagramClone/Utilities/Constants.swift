//
//  Constants.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 23.03.2023.
//


import FirebaseStorage
import FirebaseFirestore

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
let COLLECTION_USER_POSTS = Firestore.firestore().collection("user-posts")
let COLLECTION_SAVED_POSTS = Firestore.firestore().collection("saved-posts")
let COLLECTON_USERS_LIKES = Firestore.firestore().collection("users-likes")
