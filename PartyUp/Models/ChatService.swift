//
//  ChatService.swift
//  PartyUp
//
//  Created by Tyler Donohue on 3/14/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

//import Foundation
//import Scaledrone
//
//class ChatService {
//    private let scaledrone: Scaledrone
//    private let messageCallback: (Message)-> Void
//    
//    private var room: ScaledroneRoom?
//    
//    init(member: Users, onRecievedMessage: @escaping (Message)-> Void) {
//        self.messageCallback = onRecievedMessage
//        self.scaledrone = Scaledrone(
//            channelID: "3hDGwy0bxGNJll7G",//channelId will be here
//            data: member.toJSON)
//        scaledrone.delegate = self as? ScaledroneDelegate
//    }
//    
//    func connect() {
//        scaledrone.connect()
//    }
//    
//    func sendMessage(_ message: String) {
//        room?.publish(message: message)
//    }
//}
//
//// when scaledrone connects to a room it will subscribe or give an error
//extension ChatService: ScaledroneDelegate {
//    func scaledroneDidConnect(scaledrone: Scaledrone, error: NSError?) {
//        print("Connected to Scaledrone")
//        room = scaledrone.subscribe(roomName: "observable-room") //room name. MUST HAVE PREFIX "observable-"
//        room?.delegate = self as? ScaledroneRoomDelegate
//    }
//    
//    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: NSError?) {
//        print("Scaledrone error", error ?? "")
//    }
//    
//    func scaledroneDidDisconnect(scaledrone: Scaledrone, error: NSError?) {
//        print("Scaledrone disconnected", error ?? "")
//    }
//}
//
//// creates messages to String, then create a Member from the data we received in the function
//extension ChatService: ScaledroneRoomDelegate {
//    func scaledroneRoomDidConnect(room: ScaledroneRoom, error: NSError?) {
//        print("Connected to room!")
//    }
//    
//    func scaledroneRoomDidReceiveMessage(
//        room: ScaledroneRoom,
//        message: Any,
//        member: ScaledroneMember?) {
//        
//        guard
//            let text = message as? String,
//            let memberData = member?.clientData,
//            let member = Users(fromJSON: memberData)
//            else {
//                print("Could not parse data.")
//                return
//        }
//        
//        let message = Message(
//            member: member,
//            text: text,
//            messageId: UUID().uuidString)
//        messageCallback(message)
//    }
//}
