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
    @IBOutlet var emailTextField: UITextField!
    
    //add a field for their email.
    var db: Firestore!
    var currentAuthID = Auth.auth().currentUser?.uid
    var currentUser: Users?
    var userId: String?
    var locationSpot: String? = ""
    
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
                        let email = document.data()["email"] as? String,
                        let name = document.data()["name"] as? String,
                        let groupSize = document.data()["group size"] as? String,
                        let about = document.data()["about"] as? String,
                        let availability = document.data()["availability"] as? String,
                        let age = document.data()["age"] as? String,
                        let title = document.data()["title of group"] as? String {
                        
                        self.gameTextField.text = game
                        self.titleTextField.text = title
                        self.ageTextField.text = age
                        self.availabilityTextField.text = availability
                        self.aboutTextField.text = about
                        self.groupSizeTextField.text = groupSize
                        self.nameTextField.text = name
                        self.emailTextField.text = email
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
    
    //updates the users profile based on their auth Id. once saved it will give an alert and move them to LFG, other wise it will tell them an error occured and move them to LFG. I move them because the textView dissapears and only re appears if the user re enters their profile. this is to make them not freak out thinking nothing saved. once they go back to their vie profile they will se their VC filled with their info they entered
    @IBAction func saveProfileTapped(_ sender: Any) {
        
        // Auth.auth().currentUser?.uid // get current auth ID
        guard let game = gameTextField.text else { return }
        guard let titleOfGroup = titleTextField.text else { return }
        guard let groupSize = groupSizeTextField.text else  { return }
        guard let experiance = experianceSegmentedControl else  { return }
        guard let age = ageTextField.text else  { return }
        guard let availability = availabilityTextField.text else  { return }
        guard let about = aboutTextField.text else  { return }
        guard let name = nameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let location = locationSpot else { return }
        
        let user = Users(id: currentAuthID!, game: game,
                         titleOfGroup: titleOfGroup,
                         groupSize: groupSize,
                         age: age,
                         availability: availability,
                         about: about,
                         name: name, email: email, location: location)
        let userRef = self.db.collection("profile")
        
        userRef.document(String(user.id)).updateData(user.dictionary){ err in
            if err != nil {
                let alert1 = UIAlertController(title: "Not Saved", message: "Sorry, there was an error while trying to save your profile. Please try again.", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert1.dismiss(animated: true, completion: nil)
                }))
                self.present(alert1, animated: true, completion: nil)
                print("Issue here")
                print(err)
            } else {
                let alert2 = UIAlertController(title: "Saved", message: "Your profile has been saved", preferredStyle: .alert)
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
    
    @IBAction func loutOutButtonTapped(_ sender: Any) {
        print("Logged Out Tapped")
        self.currentUser = nil
        self.userId = ""
        try! Auth.auth().signOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            moveToLogIn()
        }
    }
    
    @IBAction func clearAccountButtonTapped(_ sender: UIButton) {
        let alerController = UIAlertController(title: "WARNING!", message: "This will clear you account, making you not appear in any future searches by other users!", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerController.addAction(cancel)
        let delete = UIAlertAction(title: "CLEAR ACCOUNT", style: .destructive) { _ in
            
            let game = ""
            let titleOfGroup = ""
            let groupSize = ""
            let experiance = ""
            let age = ""
            let availability = ""
            let about = ""
            let name = ""
            let email = ""
            let location = ""
            // let currentUID = self.currentAuthID
            let user = Users(id: self.currentAuthID!, game: game,
                             titleOfGroup: titleOfGroup,
                             groupSize: groupSize,
                             age: age,
                             availability: availability,
                             about: about,
                             name: name, email: email, location: location)
            let userRef = self.db.collection("profile")
            userRef.document(String(user.id)).updateData(user.dictionary){ err in
                if err == nil {
                    
                    print("Logged Out Tapped")
                    self.currentUser = nil
                    self.userId = ""
                    try! Auth.auth().signOut()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                        moveToLogIn()
                    }
                } else {
                    let alert1 = UIAlertController(title: "ERROR", message: "Sorry, there was an error while trying to clear your account, please try again", preferredStyle: .alert)
                    alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert1.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert1, animated: true, completion: nil)
                    print("document not clearned, ERROR")
                }
            }
        }
        
        alerController.addAction(delete)
        self.present(alerController, animated: true) {
        }
    }
}
