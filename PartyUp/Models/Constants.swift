//
//  Constants.swift
//  PartyUp
//
//  Created by Tyler Donohue on 2/26/20.
//  Copyright © 2020 Tyler Donohue. All rights reserved.
//

import FirebaseDatabase

struct Constants {
    struct refs {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
