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
import FirebaseStorage

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - Propeties
    
    var db: Firestore!
    var currentAuthID = Auth.auth().currentUser?.uid
    var currentUser: Users?
    var userId: String?
    var emailValue: String = "TyDonoCode@gmail.com"
    var imageString: String?
    let storage = Storage.storage()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeBackground()
    }
    
    // MARK: - Functions
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "newWizard")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func deleteProfileImage() {
        var alertStyle = UIAlertController.Style.alert
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertStyle = UIAlertController.Style.alert
        }
        let imageRef = self.storage.reference().child(self.imageString ?? "no image String found")
        imageRef.delete { err in
            if let error = err {
                let deleteImageAlert = UIAlertController(title: "Error", message: "Sorry, there was an error while trying to delete your Profile Image. Please check your internet connection and try again.", preferredStyle: alertStyle)
                deleteImageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    deleteImageAlert.dismiss(animated: true, completion: nil)
                }))
                self.present(deleteImageAlert, animated: true, completion: nil)
                print(error)
            } else {
                // File deleted successfully
            }
        }
    }

    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([emailValue])
        mailComposerVC.setSubject("Gaming Wizard: Contact Us")
        if #available(iOS 11.0, *) {
            mailComposerVC.setPreferredSendingEmailAddress(emailValue)
        } else {
            // Fallback on earlier versions
        }
        return mailComposerVC
    }
    
    func showMailError() {
        var alertStyle = UIAlertController.Style.alert
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertStyle = UIAlertController.Style.alert
        }
        let sendMailErrorAlert = UIAlertController(title: "Failed to send email", message: "Your device failed to send the email", preferredStyle: alertStyle)
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
            let age = ""
            let availability = ""
            let about = ""
            let name = ""
            let location = ""
            let contactsId = [""]
            let contactsName = [""]
            let profileImageID = ""
            let user = Users(id: self.currentAuthID!, game: game,
                             titleOfGroup: titleOfGroup,
                             groupSize: groupSize,
                             age: age,
                             availability: availability,
                             about: about,
                             name: name,
                             location: location,
                             contactsId: contactsId,
                             contactsName: contactsName,
                             profileImageID: profileImageID)
            let userRef = self.db.collection("profile")
            userRef.document(String(user.id)).updateData(user.dictionary){ err in
                if err == nil {
                    self.deleteProfileImage()
                    self.currentUser = nil
                    self.userId = ""
                    try! Auth.auth().signOut()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                        moveToLogIn()
                    }
                } else {
                    var alertStyle = UIAlertController.Style.alert
                    if (UIDevice.current.userInterfaceIdiom == .pad) {
                        alertStyle = UIAlertController.Style.alert
                    }
                    let alert1 = UIAlertController(title: "ERROR", message: "Sorry, there was an error while trying to deactivate your account, please try again", preferredStyle: alertStyle)
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
                    self.deleteProfileImage()
                    self.currentUser = nil
                    self.userId = ""
                    try! Auth.auth().signOut()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                        moveToLogIn()
                    }
                } else {
                    var alertStyle = UIAlertController.Style.alert
                    if (UIDevice.current.userInterfaceIdiom == .pad) {
                        alertStyle = UIAlertController.Style.alert
                    }
                    let alert1 = UIAlertController(title: "ERROR", message: "Sorry, there was an error while trying to delete your account, please try again", preferredStyle: alertStyle)
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
    @IBAction func contactUsHiddenButtonTapped(_ sender: UIButton) {
        let mailComposeViewcontroller = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewcontroller, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    
}
