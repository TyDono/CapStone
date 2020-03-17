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
    
    @IBOutlet weak var otherTitleLabel: UILabel!
    @IBOutlet weak var otherGameLabel: UILabel!
    @IBOutlet weak var otherAgeLabel: UILabel!
    @IBOutlet weak var otherGroupSizeLabel: UILabel!
    @IBOutlet weak var otherAvailabilityLabel: UILabel!
    @IBOutlet weak var otherAboutLabel: UILabel!
    @IBOutlet var contactMe: UIButton!
    @IBOutlet weak var otherUserNameLabel: UILabel!
    @IBOutlet weak var otherLocationLabel: UILabel!
    @IBOutlet var reportAccountPopOver: UIView!
    @IBOutlet weak var reportAccountButton: UIBarButtonItem!
    @IBOutlet weak var reportCommentsTextView: UITextView!
    
    // MARK: - Propeties
    
    var users: [Users]?
    var dbRef = Database.database().reference()
    var messages = [JSQMessage]()
    var chatRoomIdString: String?
    let currentAuthID = Auth.auth().currentUser?.uid
    var db: Firestore!
    var currentDate: String?
    
    var gameValue: String = ""
    var titleValue: String = ""
    var ageValue: String = ""
    var groupSizeValue: String = ""
    var availabilityValue: String = ""
    var aboutValue: String = ""
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
    var yourAvailability: String = ""
    var yourAbout: String = ""
    var yourName: String = ""
    var yourLocation: String = ""
    var yourContactsId: [String] = []
    var yourContactsName: [String] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = self.titleValue
        self.reportAccountPopOver.layer.cornerRadius = 10
        db = Firestore.firestore()
        dbRef = Database.database().reference()
        updateOtherProfile()
        changeBackground()
    }
    
    // MARK: - Functions
    
    func getCurrentDate() {
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "d/M/yy"
        let myDate : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        self.currentDate = myDate
    }
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Page")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.tableView.backgroundView = backgroundImage
    }
    
    func updateOtherProfile() {
        title = self.nameValue
        otherGameLabel.text = "Game: \(gameValue)"
        otherTitleLabel.text = titleValue
        otherAgeLabel.text = "Age: \(ageValue)"
        otherGroupSizeLabel.text = "Group Size: \(groupSizeValue)"
        otherAboutLabel.text = aboutValue
        otherUserNameLabel.text = "Username: \(nameValue)"
        otherAvailabilityLabel.text = "Availability: \(availabilityValue)"
        otherLocationLabel.text = "Location: \(locationValue)"
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
                         age: ageValue,
                         availability: availabilityValue,
                         about: aboutValue,
                         name: nameValue,
                         location: locationValue,
                         contactsId: contactsIdValue,
                         contactsName: contactsNameValue)
        let userRef2 = self.db.collection("profile")
        userRef2.document(String(user2.id)).updateData(user2.dictionary){ err in
            if let err = err {
                let alert1 = UIAlertController(title: "Contact Failed", message: "Sorry, there was an error while trying to add you to their contact list. Please check your internet connection and try again.", preferredStyle: .alert)
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
        getCurrentDate()
        let chatId = "no chat Id, a user was reported"
        let userReportedId = self.userIdValue
        guard let creatorId = self.currentAuthID,
            let reason = reportCommentsTextView.text,
            let dateSent = self.currentDate else { return }
        let userReportUID: String = UUID().uuidString
        let userReport = UserReport(reason: reason,
                                    creatorId: creatorId,
                                    chatId: chatId,
                                    dateSent: dateSent,
                                    reportId: userReportUID,
                                    userReportedId: userReportedId)
        let userReportRef = self.db.collection("userReports")
        userReportRef.document(userReportUID).setData(userReport.dictionary) { err in
            if let err = err {
                let reportUserFailAlert = UIAlertController(title: "Failed to report", message: "Your device failed to correctly send the report. Please make sure you have a stable internet connection.", preferredStyle: .alert)
                let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
                reportUserFailAlert.addAction(dismiss)
                self.present(reportUserFailAlert, animated: true, completion: nil)
                print(err)
                self.removePopOverAnimate()
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
        let realTimeDatabaseRef = self.dbRef.child("Messages").child(unwrappedChatRoomIdString).childByAutoId()
        
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
                        let age = document.data()["age"] as? String,
                        let title = document.data()["title of group"] as? String,
                        let location = document.data()["location"] as? String,
                        let contactsId = document.data()["contactsId"] as? [String],
                        let contactsName = document.data()["contactsName"]as? [String] else { return }
                    self.yourName = name
                    self.yourId = id
                    self.yourGame = game
                    self.yourGroupSize = groupSize
                    self.yourAbout = about
                    self.yourAvailability = availability
                    self.yourAge = age
                    self.yourTitleOfGroup = title
                    self.yourLocation = location
                    self.yourContactsId = contactsId
                    self.yourContactsName = contactsName
                    let theOtherContactName: String = name //come back to this and do soem work on this line
                    
                    for contactId in self.yourContactsId {
                        if contactId == unwrappedChatRoomIdString {
                            let alert1 = UIAlertController(title: "Contact Already Added", message: "This User is already in your contacts", preferredStyle: .alert)
                            alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                alert1.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert1, animated: true, completion: nil)
                            return
                        }
                    }
                    
                    self.yourContactsId.append(unwrappedChatRoomIdString)
                    self.contactsIdValue.append(unwrappedChatRoomIdString)
                    self.yourContactsName.append(unwrappedContactName)
                    self.contactsNameValue.append(theOtherContactName)
                }
                self.UpdateUserContacts()
                self.updateOtherUserContacts()
//                let ref = self.dbRef.child("Messages").child(unwrappedChatRoomIdString).childByAutoId()
                let message = ["sender_id": self.currentAuthID, "name": self.yourName, "text": ""]
                realTimeDatabaseRef.setValue(message)
            }
        }
    }
    
    @IBAction func reportAccountButtonTapped(_ sender: Any) {
        self.view.addSubview(reportAccountPopOver)
        showPopOverAnimate()
    }
    
    @IBAction func cencelReportButtonTapped(_ sender: UIButton) {
        removePopOverAnimate()
    }
    
    @IBAction func submitReportButtonTapped(_ sender: UIButton) {
        createReportData()
    }
    
}
