//
//  LogInViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore
import Firebase

class LogInViewController: UIViewController, GIDSignInUIDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var createAccount: UIButton!
    
    // MARK: - Propeties
    
    var db: Firestore!
    var userId: String = ""
    let userDefault = UserDefaults.standard
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        db = Firestore.firestore()
        changeBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "userSignedIn") {
            performSegue(withIdentifier: "segueToSearch", sender: self)
        }
    }
    
    // MARK: - Functions
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "newWizard")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func whiteStatusBar() -> UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
     
    // MARK: - Actions
    
    @IBAction func googleSignIn(_ sender: Any) {
        performSegue(withIdentifier: "moveToTabVC", sender: nil)
    }
    
    @IBAction func unwindToLogIn(_ sender: UIStoryboardSegue) {}
    
}
