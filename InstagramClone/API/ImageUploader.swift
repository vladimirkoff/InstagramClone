//
//  ImageUploader.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 23.03.2023.
//

import Foundation
import FirebaseStorage

struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping(String) -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let error = err {
                print("DEBUG: failed to upload image - \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, err in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
