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
import Firebase

class MyFirebase {
    
    //variables
    static let shared = MyFirebase()
    
    var currentUser: User?
    var userId: String?
    var dbRef: DatabaseReference! = Database.database().reference()
    var stprage = Storage.storage().reference()
    
    private var listenHandler: AuthStateDidChangeListenerHandle?
    var currentUpload:StorageUploadTask?
    
    private init() {
        
    }
    
    // if auth uid =  nil do nothing other wise make a document id for their acount
    //check to see if they are logged in, if they are move them to LFGVC, otherwise move them to LogInVC
    func addUserListender(loggedIn: Bool) {
        print("Add listener")
        listenHandler = Auth.auth().addStateDidChangeListener{ (auth, user) in
            if user == nil {
                //logged Out
                print("You Are Currently Logged Out")
                self.currentUser = nil
                self.userId = ""
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    if loggedIn {
                        moveToLFG()
                    } else {
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
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
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
        GIDSignIn.sharedInstance()?.signIn()
    }
    
}
