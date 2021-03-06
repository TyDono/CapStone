//
//  SearchResultsTableViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth
import GoogleSignIn
import AVFoundation

class SearchResultsTableViewController: UITableViewController {
    
    // MARK: - Propeties
    var users: [Users]?
    var db: Firestore!
    var gameValue: String!
    var text: String?
    var cellIsHidden: Bool? = false
    let currentUserId = Auth.auth().currentUser?.uid
    var audioPlayer = AVAudioPlayer()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        var users = [Users]()
        changeBackground()
        PaperSound()
        //this will search for profile documents with the same game name as what was typed in the textView in LFGVC
        db.collection("profile").whereField("game", isEqualTo: text!).getDocuments { (snapshot, error) in
            if error != nil {
                print(Error.self)
            } else {
                guard let snapshot = snapshot else {
                    print("could not unrwap snapshot")
                    return
                }
                for document in (snapshot.documents) {
                    if let userResult = document.data() as? [String: Any], let otherUser = Users.init(dictionary: userResult) {
                        users.append(otherUser)
                    }
                    print("")
                }
                self.users = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultsCell", for: indexPath) as? SearchResultsTableViewCell else { return UITableViewCell() }
        //tableView.rowHeight = 75
        if let users = users {
            let user = users[indexPath.row]
            if self.currentUserId == user.id {
                cell.isHidden = true
                self.cellIsHidden = true
            }
            cell.selectionStyle = .none
            cell.gameLabel?.text = "Game: \(user.game)"
            cell.ageLabel?.text = "Age: \(user.age)"
            cell.sizeLabel?.text = "Size: \(user.groupSize)"
            cell.titleLabel?.text = "\(user.titleOfGroup)"
            cell.locationLabel?.text = user.location
//            cell.about = user.about
//            cell.availability = user.availability
//            cell.userName = user.name
//            cell.userId = user.id
//            cell.userName = "\(user.name)"
//            cell.experiance = "\(user.experioance)"
            
            cell.updateCell(users: user)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight:CGFloat = 135.0
        if let users = users {
            let user = users[indexPath.row]
            if self.currentUserId == user.id {
//                var rowHeight:CGFloat = 0.0
                //                self.cellIsHidden == true ? (rowHeight = 0.0): (rowHeight = 135.0)
                return rowHeight
            }
        }
        return rowHeight
    }
    
    //pass in user.game and ect and have the labels print out it there.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = self.tableView.indexPathForSelectedRow?.row, let user = users?[row] {
            if segue.identifier == "viewUserSegue", let otherProfileVC = segue.destination as? ViewOtherProfileTableViewController {
                otherProfileVC.gameValue = user.game
                otherProfileVC.titleValue = user.titleOfGroup
                otherProfileVC.ageValue = user.age
                otherProfileVC.groupSizeValue = user.groupSize
                otherProfileVC.availabilityValue = user.availability
                otherProfileVC.aboutValue = user.about
                otherProfileVC.nameValue = user.name
                otherProfileVC.userIdValue = user.id
                otherProfileVC.chatRoomIdString = "\(self.currentUserId)" + "\(user.id)"
                otherProfileVC.locationValue = user.location
                otherProfileVC.contactsIdValue = user.contactsId
                otherProfileVC.contactsNameValue = user.contactsName
                otherProfileVC.profileImageIDValue = user.profileImageID
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        audioPlayer.play()
        performSegue(withIdentifier: "viewUserSegue", sender: self)
    }
    
    // MARK: - Functions
    
    func PaperSound() {
        let paperSound = Bundle.main.path(forResource: "paperSound", ofType: "wav")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: paperSound!))
        }
        catch {
            print(error)
        }
    }
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Wood")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.tableView.backgroundView = backgroundImage
    }
    
}
