//
//  Contacts.swift
//  PartyUp
//
//  Created by Tyler Donohue on 2/27/20.
//  Copyright © 2020 Tyler Donohue. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

protocol Identifiable {
    var id: String? { get set }
}

protocol DocumentContactsSerializable {
    init?(dictionary: [String: Any])
}

struct Contacts {
    var contactsIdList: [String]
    var contactsNameList: [String]
    var personalId: String
    var imageId: String
    
    var dictionary: [String: Any] {
        return [
            "contactsIdList": contactsIdList,
            "contactsNameList": contactsNameList,
            "personalId": personalId,
            "ImageId": imageId
        ]
    }
}

extension Users: DocumentContactsSerializable {
    init?(dictionary: [String: Any]) {
        guard let contactsIdList = dictionary["contactsIdList"] as? [String],
            let contactsNameList = dictionary["contactsNameList"] as? [String],
            let personalId = dictionary["personalId"] as? String,
            let imageId = dictionary["imageId"] as? String else {return nil}
        //    let color  = dictionary["color"] as? UIColor
        //let authData = dictionary["authData"] as? Any?,
        //let clientData = dictionary["clientData"] as? Any? else { return nil }
        self.init(contactsIdList: contactsIdList, contactsNameList: contactsNameList, personalId: personalId, imageId: imageId)
    }
    
}
