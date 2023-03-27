//
//  ProfileCell.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 24.03.2023.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    //MARK: - Properties
    
    var postImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .purple
        postImage.image = UIImage(named: "venom-7")
        addSubview(postImage)
        postImage.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        postImage.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
