//
//  CreateAccountTableViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateAccountTableViewController: UITableViewController{
    
    //Outlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var orOlderLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //Actions
    @IBAction func createAccountTapped(_ sender: Any) {
        
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
}
