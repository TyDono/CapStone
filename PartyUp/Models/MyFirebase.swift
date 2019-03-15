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
            } else {
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
    
    //if you log out and try to log in again it will crash. re launch the app and it wil have you re signed in. need to fix this
    func createData() {
        
        let game2: String = ""
        let titleOfGroup2: String = ""
        let groupSize2: String = ""
        let age2: String = ""
        let availability2: String = ""
        let about2: String = ""
        let name2: String = ""
       // let color2: UIColor = .red
       // let authData: Any?
        //let clientData: Any?
        
        
       // let member = Member(name: name2, color: color2)
        let user = Users(id: currentAuthID!, game: game2, titleOfGroup: titleOfGroup2, groupSize: groupSize2, age: age2, availability: availability2, about: about2, name: name2)
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
