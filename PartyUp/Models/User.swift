//
//  User.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import Foundation
import UIKit

protocol DocumentUserSerializable {
    init?(dictionary: [String: Any])
}

struct User {
    var game: String
    var id: Int
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "game": game
            
        ]
    }
    
}

extension User: DocumentUserSerializable {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
            let game = dictionary["game"] as? String else {return nil}
        self.init(game: game, id: id)
    }
}
