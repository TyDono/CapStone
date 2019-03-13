//
//  User.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

protocol Identifiable {
    var id: String? { get set }
}

protocol DocumentUserSerializable {
    init?(dictionary: [String: Any])
}

struct Users {
    var id: String
    var game: String
    var titleOfGroup: String
    var groupSize: String
    var age: String
    var availability: String
    var about: String
//    var experiance: Array = ["N/A", "Novice", "Journeyman", "Master"]
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "game": game,
            "title of group": titleOfGroup,
            "group size": groupSize,
            "age": age,
            "availability": availability,
            "about": about
            //"experaince": experiance
        ]
    }
}

extension Users: DocumentUserSerializable {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
            let game = dictionary["game"] as? String,
            let titleOfGroup = dictionary["title of group"] as? String,
            let groupSize = dictionary["group size"] as? String,
            let age = dictionary["age"] as? String,
            let availability = dictionary["availability"] as? String,
            let about = dictionary["about"] as? String else { return nil }
        self.init(id: id, game: game, titleOfGroup: titleOfGroup, groupSize: groupSize, age: age, availability: availability, about: about)
    }
}
