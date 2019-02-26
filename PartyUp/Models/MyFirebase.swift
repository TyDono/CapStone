//
//  MyFirebase.swift
//  PartyUp
//
//  Created by Tyler Donohue on 2/26/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class MyFirebase {
    
    static let shared = MyFirebase()
    
    var currentUser: User?
    var userId: String = ""
    var dbRef: DatabaseReference! = Database.database().reference()
    
    private var listenHandler: AuthStateDidChangeListenerHandle?
    
    private init() {
        
    }
    
    func addUserListender(loggedIn: Bool) {
        print("Add listener")
        listenHandler = Auth.auth().addStateDidChangeListener{ (auth, user) in
            if user == nil {
                //logged Out
                print("Logged Out")
                self.currentUser = nil
                self.userId = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if loggedIn {
                        moveToLogIn()
                    }
                }
            }
            else {
                print("Logged In")
                
                self.currentUser = user
                self.userId = (user?.uid)!
                print("UserID: \(self.userId)")
                //load data here
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    moveToLFG()
                }
            }
        }
    }
    
    func removeUserListener() {
        guard listenHandler != nil else {
            return
        }
        Auth.auth().removeStateDidChangeListener(listenHandler!)
    }
    
    func isLoggedIn() -> Bool {
        return(currentUser != nil)
    }
    
    func liknCredential(credential: AuthCredential) {
        currentUser?.linkAndRetrieveData(with: credential) {
            (user, error) in
            
            if let error = error {
                print(error)
                return
            }
            print("Credential linked")
        }
    }
    func logOut() {
        try! Auth.auth().signOut()
    }
    
}
