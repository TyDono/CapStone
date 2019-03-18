//
//  MessageDetail.swift
//  PartyUp
//
//  Created by Tyler Donohue on 3/17/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

//import Foundation
//import UIKit
//import Firebase
//import FirebaseCore
//import FirebaseDatabase
//import SwiftKeychainWrapper
//import FirebaseFirestore
//import FirebaseAuth
//
//class MessageDetail {
//    
//    private var _recipient: String = ""
//    private var _messageKey: String = ""
//    private var _messageRef: DatabaseReference!
//    var dbRef: DatabaseReference! = Database.database().reference()
//    var storage = Storage.storage().reference()
//    var currentUser: User?
//    var currentAuthID = Auth.auth().currentUser?.uid
//    
//    var recipient: String {
//        return _recipient
//    }
//    
//    var messageKey: String {
//        return _messageKey
//    }
//    
//    var messageRef: DatabaseReference {
//        return _messageRef
//    }
//    
//    init(recipient: String) {
//        _recipient = recipient
//    }
//    
//    init(messageKey: String, messageData: Dictionary<String, AnyObject>) {
//        
//        _messageKey = messageKey
//        
//        if let recipient = messageData["recipient"] as? String {
//            
//            _recipient = recipient
//        }
//        
//        _messageRef = Database.database().reference().child("recipient").child(_messageKey)
//    }
//    
//}
