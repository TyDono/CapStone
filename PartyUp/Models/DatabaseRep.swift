//
//  DatabaseRep.swift
//  PartyUp
//
//  Created by Tyler Donohue on 3/16/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import Foundation

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}
