//
//  ViewOtherProfileTableViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseDatabase
import JSQMessagesViewController
import FirebaseAuth
import FirebaseFirestore

class ViewOtherProfileTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    //MARK Outlets
    @IBOutlet var otherTitleLabel: UILabel!
    @IBOutlet var otherGameLabel: UILabel!
    @IBOutlet var otherAgeLabel: UILabel!
    @IBOutlet var otherGroupSizeLabel: UILabel!
    @IBOutlet var otherExperianceLabel: UILabel!
    @IBOutlet var otherAvailabilityLabel: UILabel!
    @IBOutlet var otherAboutLabel: UILabel!
    @IBOutlet var contactMe: UIButton!
    @IBOutlet var otherUserNameLabel: UILabel!
    @IBOutlet var otherEmailLabel: UILabel!
    
    var users: [Users]?
    var gameValue: String = ""
    var titleValue: String = ""
    var ageValue: String = ""
    var groupSizeValue: String = ""
    var experianceValue: String = ""
    var availabilityValue: String = ""
    var aboutValue: String = ""
    var text: String?
    var nameValue: String = ""
    var emailValue: String = ""
    var userId: String?
    var dbRef = Database.database().reference()
    var messages = [JSQMessage]()
    var chatRoomIdString: String?
    let currentUserId = Auth.auth().currentUser?.uid
    var yourCurrentUserName: String?
    var db: Firestore!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        dbRef = Database.database().reference()
        updateOtherProfile()
        changeBackground()
    }
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.tableView.backgroundView = backgroundImage
    }
    
    func updateOtherProfile() {
        otherGameLabel.text = "Game: \(gameValue)"
        otherTitleLabel.text = "\(titleValue)"
        otherAgeLabel.text = "Age: \(ageValue)"
        otherGroupSizeLabel.text = "Group Size: \(groupSizeValue)"
        otherExperianceLabel.text = "Experiance: \(experianceValue)"
        otherAboutLabel.text = "\(aboutValue)"
        otherUserNameLabel.text = "User Name: \(nameValue)"
        otherEmailLabel.text = "Email: \(emailValue)"
    }
    
    //MARK Actions, change to bring up and email to email the user
    @IBAction func contactMeTapped(_ sender: Any) {
        guard let unwrappedChatRoomIdString: String = self.chatRoomIdString else { return }
        print(unwrappedChatRoomIdString)
        let query = self.dbRef.child("\(unwrappedChatRoomIdString)").queryLimited(toLast: 10)
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            if  let data = snapshot.value as? [String: String],
                let id = data["sender_id"],
                let name = data["name"],
                let text = data["text"],
                !text.isEmpty {
                if let message = JSQMessage(senderId: id, displayName: name, text: text) {
                    self?.messages.append(message)
                    
                }
            }
        })
        guard let uid: String = self.currentUserId else { return }
        let profileRef = self.db.collection("profile").whereField("id", isEqualTo: uid)
        profileRef.getDocuments { (snapshot, error) in
            if error != nil {
                
                print(error as Any)
            } else {
                
                for document in (snapshot?.documents)! {
                    guard let name = document.data()["name"] as? String else { return }
                    self.yourCurrentUserName = name
                }
            }
        }
        let ref = self.dbRef.child("\(unwrappedChatRoomIdString)").childByAutoId() // call
        let message = ["sender_id": self.currentUserId, "name": self.yourCurrentUserName, "text": ""]
        ref.setValue(message)
//        let mailComposeViewcontroller = configureMailController()
//        if MFMailComposeViewController.canSendMail() {
//            self.present(mailComposeViewcontroller, animated: true, completion: nil)
//        } else {
//            showMailError()
//        }
    }
    
    //old mail function
//    func configureMailController() -> MFMailComposeViewController {
//        let mailComposerVC = MFMailComposeViewController()
//        mailComposerVC.mailComposeDelegate = self
//
//        mailComposerVC.setPreferredSendingEmailAddress(emailValue)
//        return mailComposerVC
//    }
//
//    func showMailError() {
//        let sendMailErrorAlert = UIAlertController(title: "Failed to send email", message: "Your device failed to send the email", preferredStyle: .alert)
//        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
//        sendMailErrorAlert.addAction(dismiss)
//        self.present(sendMailErrorAlert, animated: true, completion: nil)
//    }
//
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
    
}
