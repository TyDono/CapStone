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
    
    var users = [User]()
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        var users = [Users]()
       // fetchUser()
        view.backgroundColor = UIColor(displayP3Red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newMessageCell", for: indexPath) as? NewMessageTableViewCell else { return UITableViewCell() }

        let user = users[indexPath.row]
        cell.textLabel?.text = user.displayName
        cell.detailTextLabel?.text = user.email
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "segueToChat", sender: self)
        let user = self.users[indexPath.row]
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let row = self.tableView.indexPathForSelectedRow?.row, let user = users?[row] {
//            if segue.identifier == "segueToChat", let chatCellVC = segue.destination as? ChatLogCollectionViewController {
//            }
//        }
//
//    }
    
//    func fetchUser() {
//        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
//
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                var user = Users(dictionary: dictionary)
//                user?.id = snapshot.key
//                self.users.append(user)
//
//                //this will crash because of background thread, so lets use dispatch_async to fix
//                DispatchQueue.main.async(execute: {
//                    self.tableView.reloadData()
//                })
//
//            }
//
//        }, withCancel: nil)
//    }
    
}
