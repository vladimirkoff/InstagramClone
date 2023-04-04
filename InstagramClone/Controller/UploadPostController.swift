//
//  UploadPostController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 25.03.2023.
//

import UIKit
import YPImagePicker
import JGProgressHUD


class UploadPostController: UIViewController {
    //MARK: - Properties
    
    var imageData: Data?
    
    private let hud = JGProgressHUD(style: .dark)
    
    private var restrictedText = ""
    
    
    private let postImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let textView: InputTextView = {
        let tv = InputTextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy private var underline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy private var numberOfSymbols: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/100"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy private var warning: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Max number of symbols!"
        label.textColor = .red
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    //MARK: - Lifecycle
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        postImage.image = UIImage(data: imageData!)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "Post"
        textView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:    #selector(cancelPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(sharePressed))
        
        view.addSubview(postImage)
        postImage.contentMode = .scaleAspectFill
        postImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        postImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        postImage.layer.cornerRadius = 10
        postImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        
        view.addSubview(textView)
        textView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        textView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        textView.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 12).isActive = true
        
        view.addSubview(underline)
        underline.heightAnchor.constraint(equalToConstant: 1).isActive = true
        underline.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        underline.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5).isActive = true
        
        view.addSubview(numberOfSymbols)
        numberOfSymbols.bottomAnchor.constraint(equalTo: underline.topAnchor, constant: -8).isActive = true
        numberOfSymbols.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        view.addSubview(warning)
        warning.rightAnchor.constraint(equalTo: numberOfSymbols.leftAnchor, constant: -8).isActive = true
        warning.bottomAnchor.constraint(equalTo: underline.topAnchor, constant: -8).isActive = true
    }
    
    func showLoader(_ show: Bool) {
        view.endEditing(true )
        
        if show {
            self.hud.show(in: view)
        } else {
            self.hud.dismiss()
        }
    }
    
    //MARK: - Selectors
    
    @objc func cancelPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func sharePressed() {
        guard let image = postImage.image else { return }
        guard let caption = textView.text else { return }
        showLoader(true)
        
        PostService.uploadPost(caption: caption, image: image) { [weak self] error in
            self?.showLoader(false)
            if let error = error {
                print("ERROR uploadding post = \(error.localizedDescription)")
                return
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }
}


//MARK: - UITextViewDelegate

extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let num = textView.text.count
        
        if num == 100 {
            restrictedText = textView.text
        } else if num > 100 {
            textView.text = restrictedText
            warning.isHidden = false
        } else {
            warning.isHidden = true
        }
        
        numberOfSymbols.text = "\(num)/100"
    }
    
    
    
}

