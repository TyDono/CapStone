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
        var db = Firestore.firestore()
        var users = [Users]()
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
        
        if let users = users {
            let user = users[indexPath.row]
            cell.gameLabel?.text = "Game: \(user.game)"
            cell.ageLabel?.text = "Age Group: \(user.age)"
            cell.sizeLabel?.text = "Group Size: \(user.groupSize)"
            cell.titleLabel?.text = "\(user.titleOfGroup)"
            // cell.experianceLabel?.text = "\(user.experiance)"
            cell.updateCell(users: user)
        }
        return cell
    }

}
