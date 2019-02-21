//
//  CreateAccountTableViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import GoogleSignIn

class CreateAccountTableViewController: UITableViewController, GIDSignInUIDelegate {
    
    //Outlets
    @IBOutlet weak var googleCreate: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
    }
    
    //Actions
    @IBAction func createAcountGoogleTapped(_ sender: Any) {
    }
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
}
