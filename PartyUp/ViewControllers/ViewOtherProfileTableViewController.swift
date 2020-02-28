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

class ViewOtherProfileTableViewController: UITableViewController {
    
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
    var userIdValue: String = ""
    var locationValue: String = ""
    var contactsValue: [String] = [""]
    var dbRef = Database.database().reference()
    var messages = [JSQMessage]()
    var chatRoomIdString: String?
    let currentUserId = Auth.auth().currentUser?.uid
    var yourCurrentUserName: String?
    var db: Firestore!
    
    var yourId: String = ""
    var yourGame: String = ""
    var yourTitleOfGroup: String = ""
    var yourGroupSize: String = ""
    var yourAge: String = ""
    var yourAvailability: String = ""
    var yourAbout: String = ""
    var yourName: String = ""
    var yourEmail: String = ""
    var yourLocation: String = ""
    var yourContacts: [String] = [""]
    
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
    
    func UpdateUserContacts() {
        let user = Users(id: yourId,
                         game: yourGame,
                         titleOfGroup: yourTitleOfGroup,
                         groupSize: yourGroupSize,
                         age: yourAge,
                         availability: yourAvailability,
                         about:yourAbout,
                         name: yourName,
                         email: yourEmail,
                         location: yourLocation,
                         contacts: yourContacts)
        let userRef = self.db.collection("profile")
        userRef.document(String(user.id)).updateData(user.dictionary){ err in
            if let err = err {
                let alert1 = UIAlertController(title: "Contact Not Added", message: "Sorry, there was an error while trying to add them to your contacts. Please check your internet connection and try again.", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert1.dismiss(animated: true, completion: nil)
                }))
                self.present(alert1, animated: true, completion: nil)
                print("Issue here")
                print(err)
            } else {
                let alert2 = UIAlertController(title: "Contact Added", message: "Your have added them to your contacts", preferredStyle: .alert)
                alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert2.dismiss(animated: true, completion: nil)
                }))
                self.present(alert2, animated: true, completion: nil)
                //self.profileInfo()
                print("Document Saved")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                }
            }
        }
    }
    
    func updateOtherUserContacts() {
        let user2 = Users(id: userIdValue,
                         game: gameValue,
                         titleOfGroup: titleValue,
                         groupSize: groupSizeValue,
                         age: ageValue,
                         availability: availabilityValue,
                         about: aboutValue,
                         name: nameValue,
                         email: emailValue,
                         location: locationValue,
                         contacts: contactsValue)
        let userRef2 = self.db.collection("profile")
        userRef2.document(String(user2.id)).updateData(user2.dictionary){ err in
            if let err = err {
                let alert1 = UIAlertController(title: "Contact failed to accept", message: "Sorry, there was an error while trying to add you to their contact list. Please check your internet connection and try again.", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert1.dismiss(animated: true, completion: nil)
                }))
                self.present(alert1, animated: true, completion: nil)
                print("Issue here")
                print(err)
            } else {
                print("Document Saved")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                }
            }
        }
    }
    
    //MARK Actions
    
    @IBAction func contactMeTapped(_ sender: Any) {
        guard let unwrappedChatRoomIdString: String = self.chatRoomIdString else { return }
        print(unwrappedChatRoomIdString)
        let query = self.dbRef.child("\(unwrappedChatRoomIdString)").queryLimited(toLast: 10)
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            if  let data = snapshot.value as? [String: String],
                let senderId = data["sender_id"],
                let name = data["name"],
                let text = data["text"],
                !text.isEmpty {
                if let message = JSQMessage(senderId: senderId, displayName: name, text: text) {
                    self?.messages.append(message)
                }
            }
        })
        //gets your info
        guard let uid: String = self.currentUserId else { return }
        let profileRef = self.db.collection("profile").whereField("id", isEqualTo: uid)
        profileRef.getDocuments { (snapshot, error) in
            if error != nil {
                print(error as Any)
            } else {
                for document in (snapshot?.documents)! {
                    guard let name = document.data()["name"] as? String,
                        let id = document.data()["id"] as? String,
                        let game = document.data()["game"] as? String,
                        let email = document.data()["email"] as? String,
                        let groupSize = document.data()["group size"] as? String,
                        let about = document.data()["about"] as? String,
                        let availability = document.data()["availability"] as? String,
                        let age = document.data()["age"] as? String,
                        let title = document.data()["title of group"] as? String,
                        let contacts = document.data()["contacts"] as? [String] else { return }
                    self.yourCurrentUserName = name
                    self.yourId = id
                    self.yourGame = game
                    self.yourEmail = email
                    self.yourEmail = email
                    self.yourGroupSize = groupSize
                    self.yourAbout = about
                    self.yourAvailability = availability
                    self.yourAge = age
                    self.yourTitleOfGroup = title
                    self.yourContacts = contacts
                    self.yourContacts.append(unwrappedChatRoomIdString)
                    self.contactsValue.append(unwrappedChatRoomIdString)
                }
                self.UpdateUserContacts()
                self.updateOtherUserContacts()
                let ref = self.dbRef.child("Messages").child(unwrappedChatRoomIdString).childByAutoId() // call
                let message = ["sender_id": self.currentUserId, "name": self.yourCurrentUserName, "text": ""]
                ref.setValue(message)
            }
        }
    }
    
}
