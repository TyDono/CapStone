//
//  ContactsTableViewController.swift
//  PartyUp
//
//  Created by Tyler Donohue on 2/27/20.
//  Copyright © 2020 Tyler Donohue. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

class ContactsTableViewController: UITableViewController {
    
    var contactListId = [String?]()
    var contactsName = [String?]()
    var currentAuthID = Auth.auth().currentUser?.uid
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.getPersonalData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //getPersonalData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListId.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactsTableViewCell else { return UITableViewCell() }
        getPersonalData()
        if contactListId.count == 0 {
            return cell
        } else {
            let contactId = contactListId[indexPath.row]
            let contactName = contactsName[indexPath.row]
            cell.contactId = contactId
            cell.contactNameLabel.text = contactName
            return cell
        }
    }
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMessages", let messagesTVC = segue.destination as? ChatLogViewController {
            if let row = self.tableView.indexPathForSelectedRow?.row, let contactId = contactListId[row] {
                messagesTVC.chatId = contactId
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToMessages", sender: self)
    }
    
    func getPersonalData() {
        guard let uid: String = self.currentAuthID else { return }
        let profileRef = self.db.collection("profile").whereField("id", isEqualTo: uid)
        profileRef.getDocuments { (snapshot, error) in
            if error != nil {
                print(error as Any)
            } else {
                for document in (snapshot?.documents)! {
                    guard let contactList = document.data()["contactsId"] as? [String],
                        let contactName = document.data()["contactsName"] as? [String] else { return }
                    self.contactListId = contactList // getting the list
                    self.contactsName = contactName
                }
            }
        }
    }

}
