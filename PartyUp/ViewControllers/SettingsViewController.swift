//
//  SettingsViewController.swift
//  
//
//  Created by Tyler Donohue on 10/4/19.
//

import UIKit
import MessageUI
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - Propeties
    var db: Firestore!
    var currentAuthID = Auth.auth().currentUser?.uid
    var currentUser: Users?
    var userId: String?
    var emailValue: String = "TyDonoCode@gmail.com"
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeBackground()
    }
    
    // MARK: - Functions
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Title_Screen")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
      //  self.tableView.backgroundView = backgroundImage
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setPreferredSendingEmailAddress(emailValue)
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Failed to send email", message: "Your device failed to send the email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func clearAccountButtonTapped(_ sender: UIButton) {
        let alerController = UIAlertController(title: "WARNING!", message: "This will clear your profile information and clear your contact list, making you not appear in any future searches by other users!", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerController.addAction(cancel)
        let delete = UIAlertAction(title: "DEACTIVATE", style: .destructive) { _ in
            
            let game = ""
            let titleOfGroup = ""
            let groupSize = ""
            let experiance = ""
            let age = ""
            let availability = ""
            let about = ""
            let name = ""
            let location = ""
            let contactsId = [""]
            let contactsName = [""]
            let user = Users(id: self.currentAuthID!, game: game,
                             titleOfGroup: titleOfGroup,
                             groupSize: groupSize,
                             age: age,
                             availability: availability,
                             about: about,
                             name: name,
                             location: location,
                             contactsId: contactsId,
                             contactsName: contactsName)
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
                    let alert1 = UIAlertController(title: "ERROR", message: "Sorry, there was an error while trying to deactivate your account, please try again", preferredStyle: .alert)
                    alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert1.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert1, animated: true, completion: nil)
                    print("document not clearned, ERROR")
                    //                    print("Logged Out Tapped")
                    //                    self.currentUser = nil
                    //                    self.userId = ""
                    //                    try! Auth.auth().signOut()
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    //                        moveToLogIn()
                    //                    }
                }
            }
        }
        alerController.addAction(delete)
        self.present(alerController, animated: true) {
        }
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: UIButton) {
        let alerController = UIAlertController(title: "WARNING!", message: "This will delete your entire account!", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerController.addAction(cancel)
        let delete = UIAlertAction(title: "DELETE", style: .destructive) { _ in
            
            let userId = self.currentAuthID!
            let userRef = self.db.collection("profile")
            userRef.document(String(userId)).delete(){ err in
                if err == nil {
                    self.currentUser = nil
                    self.userId = ""
                    try! Auth.auth().signOut()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                        moveToLogIn()
                    }
                } else {
                    let alert1 = UIAlertController(title: "ERROR", message: "Sorry, there was an error while trying to delete your account, please try again", preferredStyle: .alert)
                    alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert1.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert1, animated: true, completion: nil)
                    print("document not deleted, ERROR")
                    //                    print("Logged Out Tapped")
                    //                    self.currentUser = nil
                    //                    self.userId = ""
                    //                    try! Auth.auth().signOut()
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    //                        moveToLogIn()
                    //                    }
                }
            }
        }
        alerController.addAction(delete)
        self.present(alerController, animated: true) {
        }
    }
    
    @IBAction func contactUsButtonTapped(_ sender: UIButton) {
        let mailComposeViewcontroller = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewcontroller, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    
}
