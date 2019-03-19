//
//  CreateAccountTableViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class CreateAccountTableViewController: UITableViewController, UIImagePickerControllerDelegate{
    
    //Outlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var orOlderLabel: UILabel!
    @IBOutlet var userImagePicker: UIImageView!
    
    var userId: String = ""
    var emailField: String = ""
    var passwordField: String = ""
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var username: String = ""
    let userDefault = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.allowsEditing = true
        view.backgroundColor = UIColor(displayP3Red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            moveToLFG()
        }
    }
    
    
    
    //Actions
    @IBAction func createAccountTapped(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailField, password: passwordField, completion: { (user, error) in
            
            if error != nil {
                
                print("Cant create user")
            } else {
                
                if user != nil {
                    
                    self.userDefault.synchronize()
                }
            }
            
        })
    }
        
        //        if let email = emailTextfield.text, let password = passwordTextField.text {
        //            Auth.auth().createUser(withEmail: email, password: password, completion: { user, error) in
        //
        //                if let firebaseError = error {
        //                    print(firebaseError.localizedDescription)
        //                    return
        //                }
        //                print("success!")
        //            })
        //        }
        //    }
    }
