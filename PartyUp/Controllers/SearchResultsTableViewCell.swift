//
//  SearchResultsTableViewCell.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/13/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import Firebase

class SearchResultsTableViewCell: UITableViewCell {
    
    //MARK outlets
    @IBOutlet var gameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var experianceLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    
    var currentAuthID = Auth.auth().currentUser?.uid
    var currentUser: Users?
    var db: Firestore!
    var users: [Users]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var db = Firestore.firestore()
    }
    
    func updateCell(users: Users) {
    }
    
    @IBAction func cellTapped(_ sender: UIButton) {
//        let profileRef = db.collection("profile").document()
//        profileRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }
    }
    
}

