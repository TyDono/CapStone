//
//  UserTableViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//



// make enum for segemned control
import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class UserTableViewController: UITableViewController {
    
    //MARK outlets
    @IBOutlet var gameTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var experianceSegmentedControl: UISegmentedControl!
    @IBOutlet var availabilityTextField: UITextView!
    @IBOutlet var aboutTextField: UITextView!
    @IBOutlet var groupSizeTextField: UITextField!
    
    var db: Firestore!
    var currentAuthID = Auth.auth().currentUser?.uid
    var currentUser: Users?
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
    }
    
    //MARK methods
    func profileInfo() {
        
       UserDefaults.standard.set(gameTextField.text, forKey: "myGame")
        gameTextField.text = ""
        UserDefaults.standard.set(titleTextField.text, forKey: "myTitle")
        titleTextField.text = ""
        UserDefaults.standard.set(ageTextField.text, forKey: "myAge")
        ageTextField.text = ""
        UserDefaults.standard.set(availabilityTextField.text, forKey: "myAvailability")
        availabilityTextField.text = ""
        UserDefaults.standard.set(aboutTextField.text, forKey: "myAbout")
        aboutTextField.text = ""
        UserDefaults.standard.set(groupSizeTextField.text, forKey: "myGroupSize")
        groupSizeTextField.text = ""
        //experianceSegmentedControl =
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let gameTextSaved = UserDefaults.standard.object(forKey: "myGame") as? String {
            gameTextField.text = gameTextSaved
        }
        if let titleTextSaved = UserDefaults.standard.object(forKey: "myTitle") as? String {
            titleTextField.text = titleTextSaved
        }
        if let ageTextSaved = UserDefaults.standard.object(forKey: "myAge") as? String {
            ageTextField.text = ageTextSaved
        }
        if let availabilityTextSaved = UserDefaults.standard.object(forKey: "myAvailability") as? String {
            availabilityTextField.text = availabilityTextSaved
        }
        if let aboutTextSaved = UserDefaults.standard.object(forKey: "myAbout") as? String {
            aboutTextField.text = aboutTextSaved
        }
        if let groupSizeTextSaved = UserDefaults.standard.object(forKey: "myGroupSize") as? String {
            groupSizeTextField.text = groupSizeTextSaved
        }
    }
    
    //MARK Actions
    @IBAction func saveProfileTapped(_ sender: Any) {
        
       // Auth.auth().currentUser?.uid // get current auth ID
        guard let game = gameTextField.text else { return }
        guard let titleOfGroup = titleTextField.text else { return }
        guard let groupSize = groupSizeTextField.text else  { return }
        guard let experiance = experianceSegmentedControl else  { return }
        guard let age = Int(ageTextField.text ?? "") else  { return }
        guard let availability = availabilityTextField.text else  { return }
        guard let about = aboutTextField.text else  { return }
        
        let user = Users(id: currentAuthID!, game: game, titleOfGroup: titleOfGroup, groupSize: groupSize, age: age, availability: availability, about: about)
        let userRef = self.db.collection("profile")
        
        userRef.document(String(user.id)).updateData(user.dictionary){ err in
            if err != nil {
                let alert1 = UIAlertController(title: "Not Saved", message: "Sorry, there was an error while trying to save your profile. Please try again.", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert1.dismiss(animated: true, completion: nil)
                }))
                self.present(alert1, animated: true, completion: nil)
                print("Issue here")
                moveToLFG()
            } else {
                let alert2 = UIAlertController(title: "Saved", message: "Your profile has been saved", preferredStyle: .alert)
                alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert2.dismiss(animated: true, completion: nil)
                }))
                self.present(alert2, animated: true, completion: nil)
                self.profileInfo()
                print("Document Saved")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    moveToLFG()
                }
                
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
    
    //MARK Actions
    
}
