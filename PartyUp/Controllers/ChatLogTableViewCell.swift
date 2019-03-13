//
//  ChatLogTableViewCell.swift
//  PartyUp
//
//  Created by Tyler Donohue on 3/13/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ChatLogTableViewCell: UITableViewCell {
    
    //outlets
    @IBOutlet weak var recipientImg: UIImageView!
    @IBOutlet weak var recipientName: UILabel!
    @IBOutlet weak var chatPreview: UILabel!

  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
