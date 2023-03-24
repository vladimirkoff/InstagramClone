//
//  SignupController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 22.03.2023.
//

import UIKit

class SignupController: UIViewController, FormViewModel {
   
    //MARK: - Properies
    
    weak var delegate: AuthDelegate?  // avoiding retain cycle

    
    var viewModel = RegistrationViewModel()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 140).isActive = true
        button.widthAnchor.constraint(equalToConstant: 140).isActive = true
        return button
    }()
    
    private let emailField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        return tf
    }()
    
    private let passwordField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let usernameField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Username")
        return tf
    }()
    
    private let fullnameField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Fullname")
        return tf
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 0.7), for: .normal)
        button.backgroundColor = .purple.withAlphaComponent(0.7)
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.attributedTitle(first: "Already have an account?  ", second: "Sign in")
        button.addTarget(self, action: #selector(goToSignin), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationsObservers()
    }
    //MARK: - Helpers
    
    func configureNavBar() {
    }
    
    func configureUI() {
        configureGradient()
        
        view.addSubview(plusButton)
        plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4).isActive = true
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [emailField, passwordField, fullnameField, usernameField, signUpButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 15).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        
        view.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        alreadyHaveAnAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func configureNotificationsObservers() {
        emailField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func updateForm() {
        signUpButton.backgroundColor = viewModel.buttonColor
        signUpButton.titleLabel?.textColor = viewModel.buttonTitleColor
        signUpButton.isEnabled = viewModel.buttonIsEnabled
    }
    
    //MARK: - Selectors
    
    @objc func registerUser() {
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        guard let fullname = fullnameField.text else { return }
        guard let username = usernameField.text else { return }
        
        let userCreds = AuthCreds(email: email, password: password, fullname: fullname, username: username, profileImage: plusButton.imageView?.image ?? UIImage(named: "profile_selected"))
        AuthService.registerUser(creds: userCreds) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            self.delegate?.authComplete()
        }
    }
    
    @objc func goToSignin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    
    @objc func textDidChange(sender: UITextField) {
        print("sender")
        if sender == emailField {
            viewModel.email = sender.text
        } else if sender == passwordField {
            viewModel.password = sender.text
        } else if sender == fullnameField {
            viewModel.fullname = sender.text
        } else {
            viewModel.username = sender.text
        }
        
        updateForm()
      
    }
}

//MARK: - UIImageControllerDelegate

extension SignupController: UIImagePickerControllerDelegate & UINavigationControllerDelegate   {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
   
        plusButton.layer.masksToBounds = true
        plusButton.layer.borderColor = UIColor.white.cgColor
        plusButton.layer.borderWidth = 2
        
        plusButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        picker.dismiss(animated: true)
    }
}
