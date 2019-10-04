//
//  SettingsViewController.swift
//  
//
//  Created by Tyler Donohue on 10/4/19.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

class SettingsViewController: UIViewController {
    
    var db: Firestore!
    var currentAuthID = Auth.auth().currentUser?.uid
    var currentUser: Users?
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func clearAccountButtonTapped(_ sender: UIButton) {
        
        let alerController = UIAlertController(title: "WARNING!", message: "This will clear your account, making you not appear in any future searches by other users!", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerController.addAction(cancel)
        let delete = UIAlertAction(title: "CLEAR ACCOUNT", style: .destructive) { _ in
            
            let game = ""
            let titleOfGroup = ""
            let groupSize = ""
            let experiance = ""
            let age = ""
            let availability = ""
            let about = ""
            let name = ""
            let email = ""
            let location = ""
            let user = Users(id: self.currentAuthID!, game: game,
                             titleOfGroup: titleOfGroup,
                             groupSize: groupSize,
                             age: age,
                             availability: availability,
                             about: about,
                             name: name, email: email, location: location)
            let userRef = self.db.collection("profile")
            userRef.document(String(user.id)).updateData(user.dictionary){ err in
                if err == nil {
                    
                    print("Logged Out Tapped")
                    self.currentUser = nil
                    self.userId = ""
                    try! Auth.auth().signOut()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                        moveToLogIn()
                    }
                } else {
                    let alert1 = UIAlertController(title: "ERROR", message: "Sorry, there was an error while trying to clear your account, please try again", preferredStyle: .alert)
                    alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert1.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert1, animated: true, completion: nil)
                    print("document not clearned, ERROR")
                    print("Logged Out Tapped")
                    self.currentUser = nil
                    self.userId = ""
                    try! Auth.auth().signOut()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        moveToLogIn()
                    }
                }
            }
        }
        alerController.addAction(delete)
        self.present(alerController, animated: true) {
        }
    }
    
}