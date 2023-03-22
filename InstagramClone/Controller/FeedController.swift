//
//  FeedController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 21.03.2023.
//

import UIKit

private let reuseIdentifier = "Cell"

class FeedController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

//MARK: - UICollectionViewDataSource
extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SELECTED")
    }
    
}

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 110
        return CGSize(width: width, height: height)
    }
}
