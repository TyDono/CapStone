//
//  User.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import Foundation
import UIKit

protocol Identifiable {
    var id: String? { get set }
}

protocol DocumentUserSerializable {
    init?(dictionary: [String: Any])
}

struct Users {
    var id: Int
    var game: String
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "game": game
            
        ]
    }
    
}

extension Users: DocumentUserSerializable {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
            let game = dictionary["game"] as? String else {return nil}
        self.init(id: id, game: game)
    }
}
