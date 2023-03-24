//
//  Constants.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 23.03.2023.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")

