//
//  LogInViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LogInViewController: UIViewController, GIDSignInUIDelegate {
    
    let userDefault = UserDefaults.standard
    
    //outlets
    @IBOutlet var createAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "usersignedin") {
            performSegue(withIdentifier: "segueToSearch", sender: self)
        }
    }
    
    func googleSignIn() {
        moveToLFG()
    }
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
            print("User Created")
                self.signInUser(email: email, password: password)
            }
        }
    }
    
    func signInUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                print("User Signed In")
                self.userDefault.set(true, forKey: "usersignedin")
                self.userDefault.synchronize()
                self.performSegue(withIdentifier: "segueToSearch", sender: self)
            } else {
                print(error)
                print(error?.localizedDescription)
            }
        }
    }
    
    //actions
    @IBAction func createAccountTapped(_ sender: Any) {
        
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        
    }
    
}
