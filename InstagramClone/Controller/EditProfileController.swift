//
//  EditProfileController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 27.03.2023.
//

import UIKit
import SDWebImage
import JGProgressHUD


class EditProfileController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    //MARK: - Properties
    
    private var user: User
    
    private let hud = JGProgressHUD(style: .dark)
    
    var infoChanged: Bool? {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    lazy private var changeProfilePhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sd_setImage(with: URL(string: user.profileImageUrl), for: .normal)
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 140).isActive = true
        button.widthAnchor.constraint(equalToConstant: 140).isActive = true
        button.layer.cornerRadius = 140 / 2
        return button
    }()
    
    private var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change profile image", for: .normal)
        button.tintColor = .blue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        return button
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    private var fullnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Full Name"
        return label
    }()
    
    private lazy var fullNameField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Username")
        tf.textColor = .black
        tf.delegate = self
        tf.layer.borderWidth = 2
        tf.text = user.fullName
        tf.layer.borderColor = UIColor.black.cgColor
        return tf
    }()
    
    private lazy var usernameField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Username")
        tf.textColor = .black
        tf.delegate = self
        tf.layer.borderWidth = 2
        tf.text = user.username
        tf.layer.borderColor = UIColor.black.cgColor
        return tf
    }()
    
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveChanges))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        view.addSubview(changeProfilePhotoButton)
        changeProfilePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeProfilePhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        
        view.addSubview(changePhotoButton)
        changePhotoButton.topAnchor.constraint(equalTo: changeProfilePhotoButton.bottomAnchor, constant: 8).isActive = true
        changePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(usernameField)
        usernameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        usernameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80).isActive = true
        usernameField.topAnchor.constraint(equalTo: changeProfilePhotoButton.bottomAnchor, constant: 100).isActive = true
        
        view.addSubview(fullNameField)
        fullNameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        fullNameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80).isActive = true
        fullNameField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10).isActive = true
        
        view.addSubview(usernameLabel)
        usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: usernameField.leftAnchor, constant: -2).isActive = true
        usernameLabel.textAlignment = .left
        usernameLabel.centerYAnchor.constraint(equalTo: usernameField.centerYAnchor).isActive = true
        
        view.addSubview(fullnameLabel)
        fullnameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
        fullnameLabel.rightAnchor.constraint(equalTo: fullNameField.leftAnchor, constant: -2).isActive = true
        fullnameLabel.textAlignment = .left
        fullnameLabel.centerYAnchor.constraint(equalTo: fullNameField.centerYAnchor).isActive = true
    }
    
    //MARK: - Helpers
    
    //MARK: - Selectors
    
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func saveChanges() {
        hud.show(in: view)
        let fullName = fullNameField.text
        let username = usernameField.text
        let uid = user.uid
        
        ImageUploader.uploadImage(image: changeProfilePhotoButton.imageView!.image!) { url in
            let data: [String : Any] = ["profileImageUrl" : url, "username" : username!, "fullName" : fullName!, "uid" : uid]
            let user = User(dictionary: data)
            UserService.updateUser(changedUser: user, completion: { error in
                self.hud.dismiss()
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
}

extension EditProfileController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        
        changeProfilePhotoButton.layer.cornerRadius = changeProfilePhotoButton.frame.width / 2
        changeProfilePhotoButton.layer.masksToBounds = true
        changeProfilePhotoButton.layer.borderColor = UIColor.white.cgColor
        changeProfilePhotoButton.layer.borderWidth = 2
        
        changeProfilePhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        picker.dismiss(animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

extension EditProfileController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        infoChanged = true
    }
}
