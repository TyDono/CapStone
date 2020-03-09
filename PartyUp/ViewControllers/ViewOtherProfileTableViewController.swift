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
    
    // MARK: - Outlets
    
    @IBOutlet var otherTitleLabel: UILabel!
    @IBOutlet var otherGameLabel: UILabel!
    @IBOutlet var otherAgeLabel: UILabel!
    @IBOutlet weak var otherAgeDesiredLabel: UILabel!
    @IBOutlet var otherGroupSizeLabel: UILabel!
    @IBOutlet var otherExperianceLabel: UILabel!
    @IBOutlet var otherAvailabilityLabel: UILabel!
    @IBOutlet var otherAboutLabel: UILabel!
    @IBOutlet var contactMe: UIButton!
    @IBOutlet var otherUserNameLabel: UILabel!
    @IBOutlet var otherLocationLabel: UILabel!
    @IBOutlet var reportAccountPopOver: UIView!
    @IBOutlet weak var reportAccountButton: UIBarButtonItem!
    @IBOutlet weak var reportCommentsTextView: UITextView!
    
    // MARK: - Propeties
    
    var users: [Users]?
    var dbRef = Database.database().reference()
    var messages = [JSQMessage]()
    var chatRoomIdString: String?
    let currentAuthID = Auth.auth().currentUser?.uid
    var yourCurrentUserName: String?
    var db: Firestore!
    var currentDate: Date?
    var chatId: String? = "no chat Id"
    
    var gameValue: String = ""
    var titleValue: String = ""
    var ageValue: String = ""
    var ageDesiredValue: String = ""
    var groupSizeValue: String = ""
    var experianceValue: String = ""
    var availabilityValue: String = ""
    var aboutValue: String = ""
    var text: String?
    var nameValue: String = ""
    var userIdValue: String = ""
    var locationValue: String = ""
    var contactsIdValue: [String] = []
    var contactsNameValue: [String] = []
    
    var yourId: String = ""
    var yourGame: String = ""
    var yourTitleOfGroup: String = ""
    var yourGroupSize: String = ""
    var yourAge: String = ""
    var yourAgeDesired: String = ""
    var yourAvailability: String = ""
    var yourAbout: String = ""
    var yourName: String = ""
    var yourLocation: String = ""
    var yourContactsId: [String] = []
    var yourContactsName: [String] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reportAccountPopOver.layer.cornerRadius = 10
        db = Firestore.firestore()
        dbRef = Database.database().reference()
        updateOtherProfile()
        changeBackground()
    }
    
    // MARK: - Functions
    
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
        otherLocationLabel.text = "User Location: \(locationValue)"
    }
    
    func UpdateUserContacts() {
        let user = Users(id: yourId,
                         game: yourGame,
                         titleOfGroup: yourTitleOfGroup,
                         groupSize: yourGroupSize,
                         yourAge: yourAge,
                         ageDesired: yourAgeDesired,
                         availability: yourAvailability,
                         about:yourAbout,
                         name: yourName,
                         location: yourLocation,
                         contactsId: yourContactsId,
                         contactsName: yourContactsName)
        let userRef = self.db.collection("profile")
        userRef.document(String(user.id)).updateData(user.dictionary){ err in
            if let err = err {
                let alert1 = UIAlertController(title: "Contact Not Added", message: "Sorry, there was an error while trying to add them to your contacts. Please check your internet connection and try again.", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert1.dismiss(animated: true, completion: nil)
                }))
                self.present(alert1, animated: true, completion: nil)
                print("Issue: UpdateUserContacts() has failed")
                print(err)
            } else {
                let alert2 = UIAlertController(title: "Contact Added", message: "Your have added them to your contacts", preferredStyle: .alert)
                alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert2.dismiss(animated: true, completion: nil)
                }))
                self.present(alert2, animated: true, completion: nil)
                //self.profileInfo()
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
                         yourAge: ageValue,
                         ageDesired: ageDesiredValue,
                         availability: availabilityValue,
                         about: aboutValue,
                         name: nameValue,
                         location: locationValue,
                         contactsId: contactsIdValue,
                         contactsName: yourContactsName)
        let userRef2 = self.db.collection("profile")
        userRef2.document(String(user2.id)).updateData(user2.dictionary){ err in
            if let err = err {
                let alert1 = UIAlertController(title: "Contact failed to accept", message: "Sorry, there was an error while trying to add you to their contact list. Please check your internet connection and try again.", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert1.dismiss(animated: true, completion: nil)
                }))
                self.present(alert1, animated: true, completion: nil)
                print("Issue: updateOtherUserContacts() has failed")
                print(err)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                }
            }
        }
    }
    
    func showPopOverAnimate() {
        self.reportAccountPopOver.center = self.view.center
        self.reportAccountPopOver.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.reportAccountPopOver.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.reportAccountPopOver.alpha = 1.0
            self.reportAccountPopOver.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removePopOverAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.reportAccountPopOver.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.reportAccountPopOver.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished) {
                    self.reportAccountPopOver.removeFromSuperview()
                }
        });
    }
    
    func createReportData() {
        guard let creatorId = self.currentAuthID,
            let chatId = self.chatId, // there will be no chatId on user reports as it is just user being reported, not their chat
            let reason = reportCommentsTextView.text,
            let dateSent = self.currentDate else { return }
        let userReportUID: String = UUID().uuidString
        let userReport = UserReport(reporterCreatorId: currentAuthID ?? "No Creator ID",
                                    reason: reason,
                                    creatorId: creatorId,
                                    chatId: chatId,
                                    dateSent: dateSent,
                                    reportId: userReportUID)
        let userReportRef = self.db.collection("userReports")
        userReportRef.document(userReportUID).setData(userReport.dictionary) { err in
            if let err = err {
                let reportUserFailAlert = UIAlertController(title: "Failed to report", message: "Your device failed to correctly send the report. Please make sure you have a stable internet connection.", preferredStyle: .alert)
                let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
                reportUserFailAlert.addAction(dismiss)
                self.present(reportUserFailAlert, animated: true, completion: nil)
                print(err)
            } else {
                let reportUserAlertSucceed = UIAlertController(title: "Thank you!", message: "Your report has been received, thank you for your report", preferredStyle: .alert)
                let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
                reportUserAlertSucceed.addAction(dismiss)
                self.removePopOverAnimate()
                self.present(reportUserAlertSucceed, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func contactMeTapped(_ sender: Any) {
        guard let unwrappedChatRoomIdString: String = self.chatRoomIdString else { return }
        guard let unwrappedContactName: String = self.nameValue else { return }
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
        guard let uid: String = self.currentAuthID else { return }
        let profileRef = self.db.collection("profile").whereField("id", isEqualTo: uid)
        profileRef.getDocuments { (snapshot, error) in
            if error != nil {
                print(error as Any)
            } else {
                for document in (snapshot?.documents)! {
                    guard let name = document.data()["name"] as? String,
                        let id = document.data()["id"] as? String,
                        let game = document.data()["game"] as? String,
                        let groupSize = document.data()["group size"] as? String,
                        let about = document.data()["about"] as? String,
                        let availability = document.data()["availability"] as? String,
                        let yourAge = document.data()["yourAge"] as? String,
                        let ageDesired = document.data()["ageDesired"] as? String,
                        let title = document.data()["title of group"] as? String,
                        let location = document.data()["location"] as? String,
                        let contactsId = document.data()["contactsId"] as? [String],
                        let contactsName = document.data()["contactsName"]as? [String] else { return }
                    self.yourCurrentUserName = name
                    self.yourId = id
                    self.yourGame = game
                    self.yourGroupSize = groupSize
                    self.yourAbout = about
                    self.yourAvailability = availability
                    self.yourAge = yourAge
                    self.ageDesiredValue = ageDesired
                    self.yourTitleOfGroup = title
                    self.yourLocation = location
                    self.yourContactsId = contactsId
                    self.yourContactsName = contactsName
                    guard let unwrappedOtherContactName: String = name else { return }
                    self.yourContactsId.append(unwrappedChatRoomIdString)
                    self.contactsIdValue.append(unwrappedChatRoomIdString)
                    self.yourContactsName.append(unwrappedContactName)
                    self.contactsNameValue.append(unwrappedOtherContactName)
                }
                self.UpdateUserContacts()
                self.updateOtherUserContacts()
                let ref = self.dbRef.child("Messages").child(unwrappedChatRoomIdString).childByAutoId() // call
                let message = ["sender_id": self.currentAuthID, "name": self.yourCurrentUserName, "text": ""]
                ref.setValue(message)
            }
        }
    }
    
    @IBAction func reportAccountButtonTapped(_ sender: Any) {
        showPopOverAnimate()
    }
    
    @IBAction func cencelReportButtonTapped(_ sender: UIButton) {
        removePopOverAnimate()
    }
    
    @IBAction func submitReportButtonTapped(_ sender: UIButton) {
        createReportData()
    }
    
}
