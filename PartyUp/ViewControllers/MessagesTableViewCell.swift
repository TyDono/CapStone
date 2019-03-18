//
//  MessagesTableViewCell.swift
//  PartyUp
//
//  Created by Tyler Donohue on 3/17/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SwiftKeychainWrapper

class MessagesTableViewCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var chatPreview: UILabel!
    
    var messageDetail: MessageDetail?
    var userPostKey: DatabaseReference!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(messageDetail: MessageDetail) {
    
        self.messageDetail = messageDetail
        
        let recipientData = Database.database().reference().child("users").child(messageDetail.recipient)
        
        recipientData.observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as! Dictionary<String, AnyObject>
            
            let username = data["username"]
            
            let userImg = data["userImg"]
            
            self.name.text = username as? String
            
            // this will be used later on to added iamges to their profile
            let ref = Storage.storage().reference(forURL: userImg! as! String)
        }
    }
    
}
