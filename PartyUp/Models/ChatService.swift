//
//  ChatService.swift
//  PartyUp
//
//  Created by Tyler Donohue on 3/14/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import Foundation
import Scaledrone

class ChatService {
    private let scaledrone: Scaledrone
    private let messageCallback: (Message)-> Void
    
    private var room: ScaledroneRoom?
    
    init(member: Member, onRecievedMessage: @escaping (Message)-> Void) {
        self.messageCallback = onRecievedMessage
        self.scaledrone = Scaledrone(
            channelID: "YOUR-CHANNEL-ID",
            data: member.toJSON)
        scaledrone.delegate = self as? ScaledroneDelegate
    }
    
    func connect() {
        scaledrone.connect()
    }
}
