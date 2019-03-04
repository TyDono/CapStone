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
import FirebaseFirestore
import GoogleSignIn
import Firebase

class MyFirebase {
    
    //variables
    static let shared = MyFirebase()
    
    var db = Firestore.firestore()
    var currentAuthID = Auth.auth().currentUser?.uid
    var currentUser: User?
    var userId: String?
    var dbRef: DatabaseReference! = Database.database().reference()
    var storage = Storage.storage().reference()
    
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
                if self.currentAuthID == nil {
                    self.createData()
                    print("new data created")
                } else {
                    print("data already added")
                }
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
    
    func createData() {
        
        var game2: String = ""
        var titleOfGroup2: String = ""
        var groupSize2: String = ""
        var age2: Int = 0
        var availability2: String = ""
        var about2: String = ""
        
        let user = Users(id: currentAuthID!, game: game2, titleOfGroup: titleOfGroup2, groupSize: groupSize2, age: age2, availability: availability2, about: about2)
        let userRef = self.db.collection("profile")
        
        userRef.document(String(user.id)).setData(user.dictionary){ err in
            if err != nil {
                print(Error.self)
            } else {
                print("Added Data")
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
