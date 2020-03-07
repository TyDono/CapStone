//
//  LogInViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//
//add segue to tabbar controller show modually, wotn mak a back button. willf ix the move to ugly issue
import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore
import Firebase

class LogInViewController: UIViewController, GIDSignInUIDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var emailTextView: UITextField!
    @IBOutlet var passwordTextView: UITextField!
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
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func whiteStatusBar() -> UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - Functions
    
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
                self.userDefault.set(true, forKey: "userSignedIn")
                self.userDefault.synchronize()
                moveToLFG()
            } else {
                print(error as Any)
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func googleSignIn(_ sender: Any) {
        performSegue(withIdentifier: "moveToTabVC", sender: nil)
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: nil)
        
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        
        if let email = emailTextView.text, let password = passwordTextView.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil {
                    self.userDefault.set(true, forKey: "uid")
                    self.userDefault.synchronize()
                    moveToLFG()
                } else {
                    print(error as Any)
                    print(error?.localizedDescription as Any)
                    self.performSegue(withIdentifier: "toSignUp", sender: nil)
                }
            })
        }
    }
    
    @IBAction func unwindToLogIn(_ sender: UIStoryboardSegue) {}
    
}
