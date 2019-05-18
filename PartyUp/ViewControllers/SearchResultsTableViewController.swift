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

class SearchResultsTableViewController: UITableViewController {
    
    //variables
    var users: [Users]?
    var db: Firestore!
    var gameValue: String!
    var text: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        var users = [Users]()
        changeBackground()
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
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.tableView.backgroundView = backgroundImage
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
        tableView.rowHeight = 75
        if let users = users {
            
            let user = users[indexPath.row]
            cell.gameLabel?.text = "Game: \(user.game)"
            cell.ageLabel?.text = "Age: \(user.age)"
            cell.sizeLabel?.text = "Size: \(user.groupSize)"
            cell.titleLabel?.text = "\(user.titleOfGroup)"
            cell.about = "\(user.about)"
            cell.availability = "\(user.availability)"
            cell.userName = "\(user.name)"
            cell.email = "\(user.email)"
            //cell.userName = "\(user.name)"
            //cell.experiance = "\(user.experioance)"
            
            cell.updateCell(users: user)
        }
        return cell
    }
    
    //pass in user.game and ect and have the labels print out it there.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let row = self.tableView.indexPathForSelectedRow?.row, let user = users?[row] {
            
            if segue.identifier == "viewUserSegue", let otherProfileVC = segue.destination as? ViewOtherProfileTableViewController {
                
                otherProfileVC.gameValue = user.game
                otherProfileVC.titleValue = user.titleOfGroup
                otherProfileVC.ageValue = user.age
                otherProfileVC.groupSizeValue = user.groupSize
                otherProfileVC.experianceValue = user.game
                otherProfileVC.aboutValue = user.about
                otherProfileVC.nameValue = user.name
                otherProfileVC.emailValue = user.email
            }
            print("prepare for viewUserSegue called")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewUserSegue", sender: self)
    }
    
}
