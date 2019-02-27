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
import Firebase

class UserTableViewController: UITableViewController {
    
    //outlets
    @IBOutlet var groupSizeLabel: UILabel!
    @IBOutlet var gameTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var experianceSegmentedControl: UISegmentedControl!
    @IBOutlet var availabilityTextField: UITextView!
    @IBOutlet var aboutTextField: UITextView!
    
    var db: Firestore!
    var currentAuthID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
    }
    
    //Actions
    @IBAction func saveProfileTapped(_ sender: Any) {
        
        Auth.auth().currentUser?.uid // get current auth ID
        guard let game = gameTextField.text else { return }
        guard let titleOfGroup = titleTextField.text else { return }
        guard let groupSize = groupSizeLabel.text else  { return }
        guard let experiance = experianceSegmentedControl else  { return }
        guard let age = Int(ageTextField.text ?? "") else  { return }
        guard let availability = availabilityTextField.text else  { return }
        guard let about = aboutTextField.text else  { return }
        
        
        
        let user = Users(id: Int(arc4random_uniform(1000001)), game: game, titleOfGroup: titleOfGroup, groupSize: groupSize, age: age, availability: availability, about: about)
        let userRef = self.db.collection("profile")
        
        userRef.document(String(user.id)).setData(user.dictionary){ err in
            if err != nil {
                print("Issue here")
            } else {
                print("Document Saved")
            }
        }
        
//        db.collection("profile").document(String(user.id)).updateData([
//            "game": game
//        ]) { err in
//            if let err = err {
//                print("Error updating document")
//            } else {
//                print("Document updated!")
//            }
//
//        }
        
    }
    
    @IBAction func groupSize(_ sender: UIStepper) {
        groupSizeLabel.text = String(sender.value)
    }
    
}
