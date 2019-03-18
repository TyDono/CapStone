//
//  MessagesTableViewController.swift
//  PartyUp
//
//  Created by Tyler Donohue on 3/17/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

//import UIKit
//import FirebaseStorage
//import FirebaseDatabase
//import Firebase
//import GoogleSignIn
//import SwiftKeychainWrapper
//
//class MessagesTableViewController: UITableViewController {
//    
//    var currentUserId: User?
//    var userId: String = ""
//    
//    var messageDetail = [MessageDetail]()
//    var detail: MessageDetail?
//    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
//    var recipient: String = ""
//    var messageId: String = ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        Database.database().reference().child("users").child(currentUser!).child("messages").observe(.value) { (snapshot) in
//            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                self.messageDetail.removeAll()
//                for data in snapshot {
//                    if let messageDict = data.value as? Dictionary<String, AnyObject> {
//                        let key = data.key
//                        let info = MessageDetail(messageKey: key, messageData: messageDict)
//                        self.messageDetail.append(info)
//                    }
//                }
//            }
//        }
//    }
//
//    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return messageDetail.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "messagesCell", for: indexPath) as? MessagesTableViewCell {
//            
//            let messageDet = messageDetail[indexPath.row]
//            cell.configureCell(messageDetail: messageDet)
//            return cell
//        } else {
//            return MessagesTableViewCell()
//        }
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        recipient = messageDetail[indexPath.row].recipient
//        
//        messageId = messageDetail[indexPath.row].messageRef.key!
//        
//        performSegue(withIdentifier: "toMessages", sender: nil)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if let destinationViewController = segue.destination as? MessageDetailTableViewController {
//            
//            destinationViewController.recipient = recipient
//            
//            destinationViewController.messageId = messageId
//        }
//    }
//    
//    @IBAction func loutOutButtonTapped(_ sender: Any) {
//        print("Logged Out")
//        self.currentUser = nil
//        self.userId = ""
//        try! Auth.auth().signOut()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            moveToLogIn()
//        }
//    }
//}
