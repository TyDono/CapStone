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
    var name: String
    var location: String
    var contactsId: [String]
    var contactsName: [String]
    var profileImageID: String
   // let color: UIColor
   // let authData: Any?
  //  let clientData: Any?
//    var experiance: Array = ["N/A", "Novice", "Journeyman", "Master"]
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "game": game,
            "title of group": titleOfGroup,
            "group size": groupSize,
            "yourAge": age,
            "availability": availability,
            "about": about,
            "name": name,
            "location": location,
            "contactsId": contactsId,
            "contactsName": contactsName,
            "profileImageID": profileImageID
            // "color": color,
            //"authData": authData,
            //"clientData": clientData
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
            let age = dictionary["yourAge"] as? String,
            let availability = dictionary["availability"] as? String,
            let about = dictionary["about"] as? String,
            let name = dictionary["name"] as? String,
            let location = dictionary["location"] as? String,
            let contactsId = dictionary["contactsId"] as? [String],
            let contactsName = dictionary["contactsName"] as? [String],
            let profileImageID = dictionary["profileImageID"] as? String else {return nil}
        //let color  = dictionary["color"] as? UIColor
        //let authData = dictionary["authData"] as? Any?,
        //let clientData = dictionary["clientData"] as? Any? else { return nil }
        self.init(id: id, game: game, titleOfGroup: titleOfGroup, groupSize: groupSize, age: age, availability: availability, about: about, name: name, location: location, contactsId: contactsId, contactsName: contactsName, profileImageID: profileImageID)
    }
    
}
