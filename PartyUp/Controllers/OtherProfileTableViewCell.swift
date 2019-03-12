//
//  OtherProfileTableViewCell.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit

class OtherProfileTableViewCell: UITableViewCell {
    
    @IBOutlet var otherGameLabel: UILabel!
    
    var users: [Users]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(users: Users) {
    }

}
