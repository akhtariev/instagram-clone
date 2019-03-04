//
//  SignUpVC.swift
//  instagram-clone
//
//  Created by Roman Akhtariev on 2019-02-11.
//  Copyright © 2019 Roman Akhtariev. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC:
    UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    var imageSelected = false

    let plusPhotoButton: UIButton =
    {
        let button = UIButton(type: .system)
        let profileLogoName = "plus_photo.png"
        let profileLogo = UIImage(named: profileLogoName)!
        button.setImage(
            profileLogo.withRenderingMode(.alwaysOriginal),
            for: .normal)
        button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField =
    {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let passowrdTextField: UITextField =
    {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let fullNameTextField: UITextField =
    {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField: UITextField =
    {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let signUpButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton =
    {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(
            string: "Already have an account?   ",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(
            string: "Sign In",
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor(
                    red: 17/255,
                    green: 154/255,
                    blue: 237/255,
                    alpha: 1)]))
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // background colour
        view.backgroundColor = .white
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(
            top: view.topAnchor,
            left: nil,
            bottom: nil,
            right: nil,
            paddingTop: 40,
            paddingLeft: 0,
            paddingBottom: 0,
            paddingRight: 0,
            width: 140,
            height: 140)
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        configureViewComponents()
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(
            top: nil,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            paddingTop: 0 ,
            paddingLeft: 0,
            paddingBottom: 0,
            paddingRight: 0,
            width: 0,
            height: 50)
    }
    
    @objc func handleShowLogin()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp()
    {
        // properties
        guard let email = emailTextField.text else { return }
        guard let password = passowrdTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password)
        { (authResult, error) in
            // handle error
            
            if let error = error
            {
                print("Failed to create user with error: ", error.localizedDescription)
                return
            }
            
            // set profile image
            guard let profileImage = self.plusPhotoButton.imageView?.image else { return }
            
            // upload data
            guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
            
            //place image in Firebase storage
            let filename = NSUUID().uuidString // unique
            
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            storageRef.putData(imageData, metadata: nil, completion:
                {
                    (metadata, error) in
                
                // handle error
                if let error = error
                {
                    print("Failed to upload image to Firebase Storage with error", error.localizedDescription)
                    return
                }
                    
                    storageRef.downloadURL(completion:
                        { (downloadURL, error) in
                            guard let profileImageUrl = downloadURL?.absoluteString else
                        {
                            return
                            }
                            guard let uid = authResult?.user.uid else { return }
                            let dictionaryValues = [
                                "name": fullName,
                                "username": username,
                                "profileImageUrl": profileImageUrl]
                            let values = [uid: dictionaryValues]
                            
                            USER_REF.updateChildValues(
                                values,
                                withCompletionBlock:
                                { (error, ref) in  
                                
                                // dismiss login controller
                                self.dismiss(animated: true, completion: nil)                            })
                    })
                    
                    
                
                
                
            })
        }
    }
    
    @objc func formValidation()
    {
        guard
            emailTextField.hasText,
            passowrdTextField.hasText,
            usernameTextField.hasText,
            fullNameTextField.hasText,
            imageSelected == true
            else
        {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
    
    @objc func handleSelectProfilePhoto()
    {
        // configure image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        // present image picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // called once the image is selected: inherited from UIImagePickerControllerDelegate
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage]
            as? UIImage
            else
        {
            imageSelected = false
            return
        }
        
        // set imageSelected to true
        imageSelected = true
        
        // configure plusPhotoButton with selected image
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2;
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureViewComponents()
    {
        let stackView = UIStackView(arrangedSubviews:
            [emailTextField,
             fullNameTextField,
             usernameTextField,
             passowrdTextField,
             signUpButton])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(
            top: plusPhotoButton.bottomAnchor,
            left: view.leftAnchor,
            bottom: nil,
            right: view.rightAnchor,
            paddingTop: 24,
            paddingLeft: 20,
            paddingBottom: 0,
            paddingRight: 20,
            width: 0,
            height: 240)
    }
}
