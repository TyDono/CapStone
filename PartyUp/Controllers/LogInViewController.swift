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
    
    //actions
    @IBAction func createAccountTapped(_ sender: Any) {
        
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        
    }
    
}
