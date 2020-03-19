//
//  ViewPersonalAccountTableViewController.swift
//  Gaming Wizard
//
//  Created by Tyler Donohue on 3/16/20.
//  Copyright © 2020 Tyler Donohue. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseDatabase
import JSQMessagesViewController
import FirebaseAuth
import FirebaseFirestore

class ViewPersonalAccountTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var profileUIImage: UIImageView!
    @IBOutlet weak var otherTitleLabel: UILabel!
    @IBOutlet weak var otherGameLabel: UILabel!
    @IBOutlet weak var otherAgeLabel: UILabel!
    @IBOutlet weak var otherGroupSizeLabel: UILabel!
    @IBOutlet weak var otherAvailabilityLabel: UILabel!
    @IBOutlet weak var otherAboutLabel: UILabel!
    @IBOutlet weak var otherUserNameLabel: UILabel!
    @IBOutlet weak var otherLocationLabel: UILabel!
    @IBOutlet var reportAccountPopOver: UIView!
    @IBOutlet weak var reportCommentsTextView: UITextView!
    
    // MARK: - Propeties
    
    var users: [Users]?
    var dbRef = Database.database().reference()
    var messages = [JSQMessage]()
    var chatRoomIdString: String?
    let currentAuthID = Auth.auth().currentUser?.uid
    var db: Firestore!
    var currentDate: String?
    
    var yourId: String?
    var yourGame: String?
    var yourTitleOfGroup: String?
    var yourGroupSize: String?
    var yourAge: String?
    var yourAvailability: String?
    var yourAbout: String?
    var yourName: String?
    var yourLocation: String?
    var yourContactsId: [String] = []
    var yourContactsName: [String] = []
    var profileImageID: String?
    var profileImage: UIImage?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = self.yourTitleOfGroup
        updateOtherProfile()
        db = Firestore.firestore()
        changeBackground()
    }
    
    // MARK: - Functions
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Page")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.tableView.backgroundView = backgroundImage
    }
    
    func updateOtherProfile() {
        title = self.yourTitleOfGroup
        guard let yourGame = self.yourGame,
            let yourTitleOfGroup = self.yourTitleOfGroup,
            let yourAge = self.yourAge,
            let yourGroupSize = self.yourGroupSize,
            let yourAbout = self.yourAbout,
            let yourName = self.yourName,
            let yourAvailability = self.yourAvailability,
            let yourLocation = yourLocation else { return }
        otherGameLabel.text = "Game: \(yourGame)"
        otherTitleLabel.text = yourTitleOfGroup
        otherAgeLabel.text = "Age: \(yourAge)"
        otherGroupSizeLabel.text = "Group Size: \(yourGroupSize)"
        otherAboutLabel.text = yourAbout
        otherUserNameLabel.text = "Username: \(yourName)"
        otherAvailabilityLabel.text = "Availability: \(yourAvailability)"
        otherLocationLabel.text = "Location: \(yourLocation)"
    }

    // MARK: - Actions
    
}
