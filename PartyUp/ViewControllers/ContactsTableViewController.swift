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
    
    var contactList = [String?]()
    var currentAuthID = Auth.auth().currentUser?.uid
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.getPersonalData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactsTableViewCell else { return UITableViewCell() }
        
        let contact = contactList[indexPath.row]
        cell.contactNameLabel.text = contact
        return cell
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
            if let row = self.tableView.indexPathForSelectedRow?.row, let contact = contactList[row] {
                messagesTVC.chatId = contact
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
                    guard let contactList = document.data()["contactList"] as? [String] else { return }
                    self.contactList = contactList
                }
            }
        }
    }

}
