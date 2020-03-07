//
//  SearchResultsTableViewCell.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/13/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit


class SearchResultsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet var gameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    
    // MARK: - Propeties
    var users: [Users]?
    var experience: String = ""
    var about: String = ""
    var availability: String = ""
    var userName: String = ""
    var name: String = ""
    var userId: String = ""
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    // MARK: - Functions
    
    func updateCell(users: Users) {
    }
    
}

