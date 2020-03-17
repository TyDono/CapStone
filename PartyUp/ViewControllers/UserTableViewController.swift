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
import GoogleSignIn

class UserTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var gameTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var yourAgeTextField: UITextField!
    @IBOutlet var availabilityTextField: UITextView!
    @IBOutlet var aboutTextField: UITextView!
    @IBOutlet var groupSizeTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    
    // MARK: - Propeties
    
    var db: Firestore!
    var currentAuthID = Auth.auth().currentUser?.uid
    var currentUser: Users?
    var userId: String?
    var locationSpot: String? = ""
    var contactsName = [""]
    var contactsId = [""]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        changeBackground()
        getPersonalData()
    }
    
    // MARK: - Functions
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Page")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.tableView.backgroundView = backgroundImage
    }
    
    func getPersonalData() {
        
        guard let uid: String = self.currentAuthID else { return }
        print("this is my uid i really like my uid \(uid)")
        let profileRef = self.db.collection("profile").whereField("id", isEqualTo: uid)
        profileRef.getDocuments { (snapshot, error) in
            if error != nil {
                print(error as Any)
            } else {
                for document in (snapshot?.documents)! {
                    if let game = document.data()["game"] as? String,
                        let name = document.data()["name"] as? String,
                        let groupSize = document.data()["group size"] as? String,
                        let about = document.data()["about"] as? String,
                        let availability = document.data()["availability"] as? String,
                        let yourAge = document.data()["age"] as? String,
                        let title = document.data()["title of group"] as? String,
                        let location = document.data()["location"] as? String,
                        let contactsId = document.data()["contactsId"] as? [String],
                        let contactsName = document.data()["contactsName"] as? [String] {
                        
                        self.gameTextField.text = game
                        self.titleTextField.text = title
                        self.yourAgeTextField.text = yourAge
                        self.availabilityTextField.text = availability
                        self.aboutTextField.text = about
                        self.groupSizeTextField.text = groupSize
                        self.nameTextField.text = name
                        self.locationTextField.text = location
                        self.contactsId = contactsId
                        self.contactsName = contactsName
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToViewAccount", let otherProfileVC = segue.destination as? ViewPersonalAccountTableViewController {
            otherProfileVC.yourGame = self.gameTextField.text ?? ""
            otherProfileVC.yourTitleOfGroup = self.titleTextField.text ?? ""
            otherProfileVC.yourAge = self.yourAgeTextField.text ?? ""
            otherProfileVC.yourGroupSize = self.groupSizeTextField.text ?? ""
            otherProfileVC.yourAvailability = self.availabilityTextField.text
            otherProfileVC.yourAbout = self.aboutTextField.text
            otherProfileVC.yourName = self.nameTextField.text ?? ""
            otherProfileVC.yourLocation = self.locationTextField.text ?? ""
        }
    }
    
    // MARK: - Actions
    
    @IBAction func settingBarButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "settingsSegue", sender: nil)
    }
    
    @IBAction func saveProfileTapped(_ sender: Any) {
        // Auth.auth().currentUser?.uid // get current auth ID
        guard let game = gameTextField.text,
            let titleOfGroup = titleTextField.text,
            let groupSize = groupSizeTextField.text,
            let yourAge = yourAgeTextField.text,
            let availability = availabilityTextField.text,
            let about = aboutTextField.text,
            let name = nameTextField.text,
            let location = locationTextField.text else { return }
        let contactsId = self.contactsId
        let contactsName = self.contactsName
        
        let user = Users(id: currentAuthID!,
                         game: game,
                         titleOfGroup: titleOfGroup,
                         groupSize: groupSize,
                         age: yourAge,
                         availability: availability,
                         about: about,
                         name: name,
                         location: location,
                         contactsId: contactsId,
                         contactsName: contactsName)
        let userRef = self.db.collection("profile")
        
        userRef.document(String(user.id)).updateData(user.dictionary){ err in
            if let err = err {
                let alert1 = UIAlertController(title: "Not Saved", message: "Sorry, there was an error while trying to save your profile. Please try again.", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert1.dismiss(animated: true, completion: nil)
                }))
                self.present(alert1, animated: true, completion: nil)
                print("Issue: saveProfileTapped() has failed")
                print(err)
            } else {
                let alert2 = UIAlertController(title: "Saved", message: "Your profile has been saved", preferredStyle: .alert)
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
    
    @IBAction func loutOutButtonTapped(_ sender: Any) {
        self.currentUser = nil
        self.userId = ""
        try! Auth.auth().signOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            moveToLogIn()
        }
    }
    
    @IBAction func viewAccountButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToViewAccount", sender: nil)
    }
    
}
