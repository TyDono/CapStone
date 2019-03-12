//
//  ViewOtherProfileTableViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth

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
    
    var users: [Users]?
    var db: Firestore!
    var gameValue: String!
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var db = Firestore.firestore()
        
    }
    
//    func getUser() {
//
//        guard let game = otherGameLabel.text else { return }
//        guard let titleOfGroup = otherTitleLabel.text else { return }
//        guard let groupSize = otherGroupSizeLabel.text else  { return }
//        guard let experiance = otherExperianceLabel else  { return }
//        guard let age = otherAgeLabel.text else  { return }
//        guard let availability = otherAvailabilityLabel.text else  { return }
//        guard let about = otherAboutLabel.text else  { return }
//
//        let user = Users(id: currentAuthID!, game: game, titleOfGroup: titleOfGroup, groupSize: groupSize, age: age, availability: availability, about: about)
//        let users = [Users]()
//        let userRef = db.collection("profile")
//        userRef.document("3UMne2zHGZgd5vb4urjuI6IddFV2").getDocument() { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("docuemnt data: \(dataDescription)")
//            } else {
//                print("ERROR, docuemnt does not exist")
//            }
//        }
//
//    }
    
    //    var user: Users? {
    //        return Users.init(dictionary: <#T##[String : Any]#>)
    //    }
    
//    func getDocument() {
//
//        let docRef = db.collection("profile").document("3UMne2zHGZgd5vb4urjuI6IddFV2")
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let gameCell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as? OtherProfileTableViewCell else { return UITableViewCell() }
//
//        if let users = users {
//            let user = users[indexPath.row]
//            otherGameLabel?.text = "Game: \(user.game)"
//        }
    //        return gameCell
    //    }
    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return 6
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as? OtherProfileTableViewCell else { return UITableViewCell() }
//
//        if let users = users {
//
//            let user = users[indexPath.row]
//            cell.otherGameLabel?.text = "Game: \(user.game)"
//            cell.updateCell(users: user)
//        }
//        return cell
//    }
    
    //    func updateOtherProfile() {
    //        if let users = users {
    //            let user = users
//            otherAboutLabel?.text = "\(user.about)"
//            otherAvailabilityLabel?.text = "\(user.availability)"
//            otherGameLabel?.text = "Game: \(user.game)"
//            otherAgeLabel?.text = "Group Age: \(user.age)"
//            otherGroupSizeLabel?.text = "Group Size: \(user.groupSize)"
//            otherTitleLabel?.text = "\(user.titleOfGroup)"
//
//        }
//    }
    
//    func otherProfileInfo() {
//
//        UserDefaults.standard.set(otherGameLabel.text, forKey: "otherGame")
//        otherGameLabel.text = ""
//        UserDefaults.standard.set(otherTitleLabel.text, forKey: "otherTitle")
//        otherTitleLabel.text = ""
//        UserDefaults.standard.set(otherAgeLabel.text, forKey: "otherAge")
//        otherAgeLabel.text = ""
//        UserDefaults.standard.set(otherAvailabilityLabel.text, forKey: "otherAvailability")
//        otherAvailabilityLabel.text = ""
//        UserDefaults.standard.set(otherAboutLabel, forKey: "otherAbout")
//        otherAboutLabel.text = ""
//        UserDefaults.standard.set(otherGroupSizeLabel.text, forKey: "otherGroupSize")
//        otherGroupSizeLabel.text = ""
//        UserDefaults.standard.set(otherExperianceLabel, forKey: "otherExperiance")
//        otherExperianceLabel.text = ""
//
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        if let gameTextSaved = UserDefaults.standard.object(forKey: "otherGame") as? String {
//            otherGameLabel.text = gameTextSaved
//        }
//        if let titleTextSaved = UserDefaults.standard.object(forKey: "otherTitle") as? String {
//            otherTitleLabel.text = titleTextSaved
//        }
//        if let ageTextSaved = UserDefaults.standard.object(forKey: "otherAge") as? String {
//            otherAgeLabel.text = ageTextSaved
//        }
//        if let availabilityTextSaved = UserDefaults.standard.object(forKey: "otherAvailability") as? String {
//            otherAvailabilityLabel.text = availabilityTextSaved
//        }
//        if let aboutTextSaved = UserDefaults.standard.object(forKey: "otherAbout") as? String {
//            otherAboutLabel.text = aboutTextSaved
//        }
//        if let groupSizeTextSaved = UserDefaults.standard.object(forKey: "otherGroupSize") as? String {
//            otherGroupSizeLabel.text = groupSizeTextSaved
//        }
//        if let otherExperianceSaved = UserDefaults.standard.object(forKey: "otherExperiance") as? String {
//            otherExperianceLabel.text = otherExperianceSaved
//        }
//    }
    
    //MARK Actions
    @IBAction func contactMeTapped(_ sender: Any) {
        
    }
    
}
