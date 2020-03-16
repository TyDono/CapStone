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
    
    var reason: String
    var creatorId: String
    var chatId: String
    var dateSent: String
    var reportId: String
    var userReportedId: String
    
    var dictionary: [String: Any] {
        return [
            "reason": reason,
            "creatorId": creatorId,
            "chatId:": chatId,
            "dateSent": dateSent,
            "reportId": reportId,
            "userReportedId": userReportedId
        ]
    }
}

extension UserReport: DocumentSerializableUserReport {
    init?(dictionary: [String: Any]) {
        guard let reason = dictionary["reason"] as? String,
            let creatorId = dictionary["creatorId"] as? String,
            let chatId = dictionary["chatId"] as? String,
            let dateSent = dictionary["dateSent"] as? String,
            let reportId = dictionary["reportId"] as? String,
            let userReportedId = dictionary["userReportedId"] as? String else {return nil}
        self.init(reason: reason, creatorId: creatorId, chatId: chatId, dateSent: dateSent, reportId: reportId, userReportedId: userReportedId)
    }
    
}
