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
import GoogleSignIn

class UserTableViewController: UITableViewController {
    
    //MARK outlets
    @IBOutlet var gameTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var experianceSegmentedControl: UISegmentedControl!
    @IBOutlet var availabilityTextField: UITextView!
    @IBOutlet var aboutTextField: UITextView!
    @IBOutlet var groupSizeTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    
    var db: Firestore!
    var currentAuthID = Auth.auth().currentUser?.uid
    var currentUser: Users?
    var userId: String?
    var locationSpot: String? = ""
    var contactsName = [""]
    var contactsId = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        changeBackground()
        getPersonalData()
    }
    
    func changeBackground() {
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.tableView.backgroundView = backgroundImage
    }
    
    //MARK methods
    //    func profileInfo() {
    //
    //       UserDefaults.standard.set(gameTextField.text, forKey: "myGame")
    //        gameTextField.text = ""
    //        UserDefaults.standard.set(titleTextField.text, forKey: "myTitle")
    //        titleTextField.text = ""
    //        UserDefaults.standard.set(ageTextField.text, forKey: "myAge")
    //        ageTextField.text = ""
    //        UserDefaults.standard.set(availabilityTextField.text, forKey: "myAvailability")
    //        availabilityTextField.text = ""
    //        UserDefaults.standard.set(aboutTextField.text, forKey: "myAbout")
    //        aboutTextField.text = ""
    //        UserDefaults.standard.set(groupSizeTextField.text, forKey: "myGroupSize")
    //        groupSizeTextField.text = ""
    //        UserDefaults.standard.set(nameTextField.text, forKey: "myName")
    //        nameTextField.text = ""
    //        UserDefaults.standard.set((emailTextField.text), forKey: "email")
    //        emailTextField.text = ""
    //        //experianceSegmentedControl =
    //
    //  }
    
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
                        let age = document.data()["age"] as? String,
                        let title = document.data()["title of group"] as? String,
                        let location = document.data()["location"] as? String,
                        let contactsId = document.data()["contactsId"] as? [String],
                        let contactsName = document.data()["contactsName"] as? [String] {
                        
                        self.gameTextField.text = game
                        self.titleTextField.text = title
                        self.ageTextField.text = age
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
    
    //        if let gameTextSaved = UserDefaults.standard.object(forKey: "myGame") as? String {
    //            gameTextField.text = gameTextSaved
    //        }
    //        if let titleTextSaved = UserDefaults.standard.object(forKey: "myTitle") as? String {
    //            titleTextField.text = titleTextSaved
    //        }
    //        if let ageTextSaved = UserDefaults.standard.object(forKey: "myAge") as? String {
    //            ageTextField.text = ageTextSaved
    //        }
    //        if let availabilityTextSaved = UserDefaults.standard.object(forKey: "myAvailability") as? String {
    //            availabilityTextField.text = availabilityTextSaved
    //        }
    //        if let aboutTextSaved = UserDefaults.standard.object(forKey: "myAbout") as? String {
    //            aboutTextField.text = aboutTextSaved
    //        }
    //        if let groupSizeTextSaved = UserDefaults.standard.object(forKey: "myGroupSize") as? String {
    //            groupSizeTextField.text = groupSizeTextSaved
    //        }
    //        if let nameTextSaved = UserDefaults.standard.object(forKey: "myName") as? String {
    //            nameTextField.text = nameTextSaved
    //        }
    //        if let emailTextSaved = UserDefaults.standard.object(forKey: "email") as? String {
    //            emailTextField.text = emailTextSaved
    //        }
    //    }
    //
    //MARK Actions
    
    @IBAction func settingBarButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "settingsSegue", sender: nil)
    }
    
    @IBAction func saveProfileTapped(_ sender: Any) {
        // Auth.auth().currentUser?.uid // get current auth ID
        guard let game = gameTextField.text,
            let titleOfGroup = titleTextField.text,
            let groupSize = groupSizeTextField.text,
            let experiance = experianceSegmentedControl,
            let age = ageTextField.text,
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
                         age: age,
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
    
}
