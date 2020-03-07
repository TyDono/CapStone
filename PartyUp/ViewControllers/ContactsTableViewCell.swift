//
//  ContactsTableViewCell.swift
//  PartyUp
//
//  Created by Tyler Donohue on 2/27/20.
//  Copyright © 2020 Tyler Donohue. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var contactProfileImage: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    
    // MARK: - Propeties
    
    var contactId: String?
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
