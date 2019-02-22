//
//  UserTableViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UserTableViewController: UITableViewController {
    
    //outlets
    @IBOutlet var groupSizeLabel: UILabel!
    @IBOutlet var gameTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var experianceSegmentedControl: UISegmentedControl!
    @IBOutlet var availabilityTextField: UITextView!
    @IBOutlet var aboutTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataBase = Firestore.firestore()
        
    }
    
    //Actions
    @IBAction func saveProfileTapped(_ sender: Any) {
        Firestore.firestore().collection("profile").addDocument(data: [
            "game": gameTextField.text
        ]) { (error) in
            if let error = error {
                print(error)
            } else {
                print("Data added to Firebase")
            }
        }
        
    }
    
    @IBAction func groupSize(_ sender: UIStepper) {
        groupSizeLabel.text = String(sender.value)
    }
    
}
