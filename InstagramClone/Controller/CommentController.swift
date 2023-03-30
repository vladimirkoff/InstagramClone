//
//  CommentController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 30.03.2023.
//

import UIKit

private var reuseIdentifier = "CommentCell"

class CommentController: UICollectionViewController {
    
    //MARK: - Properties
    
    lazy private var textView: CommentTextView = {
//        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let tv = CommentTextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return textView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    
    lazy private var underline: UIView = {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = .lightGray
         return view
     }()
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.title = "Comments"
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        view.addSubview(textView)
        textView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        
        view.addSubview(underline)
        underline.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: 1).isActive = true
        underline.heightAnchor.constraint(equalToConstant: 1).isActive = true
        underline.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
    
    }
    
    //MARK: - Selectors
    
    @objc func cancelPressed() {
        self.dismiss(animated: true)
    }
    
}

extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}

extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
}
