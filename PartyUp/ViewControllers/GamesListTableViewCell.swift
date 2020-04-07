//
//  GamesListTableViewCell.swift
//  Gaming Wizard
//
//  Created by Tyler Donohue on 4/7/20.
//  Copyright © 2020 Tyler Donohue. All rights reserved.
//

import UIKit

class GamesListTableViewCell: UITableViewCell {

    @IBOutlet weak var GameNameLabel: UILabel!
    
    var gameName: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
