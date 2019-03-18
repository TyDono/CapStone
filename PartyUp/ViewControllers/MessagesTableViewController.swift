//
//  MessagesTableViewController.swift
//  PartyUp
//
//  Created by Tyler Donohue on 3/17/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import GoogleSignIn
import SwiftKeychainWrapper

class MessagesTableViewController: UITableViewController {
    
    var currentUser: User?
    var userId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagesCell", for: indexPath)


        return cell
    }

    @IBAction func loutOutButtonTapped(_ sender: Any) {
        print("Logged Out")
        self.currentUser = nil
        self.userId = ""
        try! Auth.auth().signOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            moveToLogIn()
        }
    }
}
