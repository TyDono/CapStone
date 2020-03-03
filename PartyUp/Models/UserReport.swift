//
//  UserReport.swift
//  PartyUp
//
//  Created by Tyler Donohue on 3/3/20.
//  Copyright © 2020 Tyler Donohue. All rights reserved.
//

import Foundation

protocol IdentifiableUserReport {
    var id: String? { get set }
}

protocol DocumentSerializableUserReport {
    init?(dictionary: [String: Any])
}

struct UserReport {
    
    var reporterCreatorId: String
    var reason: String
    var creatorId: String
    var chatId: String
    var storyId: String
    
    var dictionary: [String: Any] {
        return [
            "reporterCreatorId": reporterCreatorId,
            "reason": reason,
            "creatorId": creatorId,
            "chatId:": chatId,
            "storyId": storyId
        ]
    }
}

extension UserReport: DocumentSerializableUserReport {
    init?(dictionary: [String: Any]) {
        guard let reporterCreatorId = dictionary["reporterCreatorId"] as? String,
            let reason = dictionary["reason"] as? String,
            let creatorId = dictionary["creatorId"] as? String,
            let graveId = dictionary["chatId:"] as? String,
            let storyId = dictionary["storyId"] as? String else {return nil}
        self.init(reporterCreatorId: reporterCreatorId, reason: reason, creatorId: creatorId, graveId: graveId, storyId: storyId)
    }
    
}
