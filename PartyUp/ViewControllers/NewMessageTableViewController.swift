//
//  NewMessageTableViewController.swift
//  PartyUp
//
//  Created by Tyler Donohue on 3/17/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class NewMessageTableViewController: UITableViewController {
    
    var users: [Users]?
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        var users = [Users]()
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newMessageCell", for: indexPath) as? NewMessageTableViewCell else { return UITableViewCell() }

        if let users = users {
            
            let user = users[indexPath.row]
        cell.name.text = user.name
        
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToChat", sender: self)
        let user = self.users?[indexPath.row]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = self.tableView.indexPathForSelectedRow?.row, let user = users?[row] {
            if segue.identifier == "segueToChat", let chatCellVC = segue.destination as? ChatLogCollectionViewController {
            }
        }
        
    }
    
}
