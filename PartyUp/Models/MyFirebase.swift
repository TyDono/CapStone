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
import GoogleSignIn
import FirebaseFirestore
import Firebase

class MyFirebase {
    
    // Variables
    static let shared = MyFirebase()
    
    //var dataBse = Database.database().reference().child("messages")
    var db = Firestore.firestore()
    var currentAuthID = Auth.auth().currentUser?.uid
    var currentUser: User?
    var userId: String? = ""
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
                // check for docuemnt named the same as their user id, if it does not exist it will create a document for them to use, otherwise nothing will happen. should should only be called once when they user logs in and never again unless their account is deleted.
                print("Logged In")
                let userReff = self.db.collection("profile").document("\(String(describing: self.userId))")
                userReff.getDocument { (document, error) in
                    print(document)
                    guard let document = document?.exists else { return }
                    if document == true {
                        print("data already added: \(document)")
                    } else {
                        self.createData()
                        print("document added to fireStore")
                    }
                    self.currentUser = user
                    self.userId = (user?.uid)!
                    print("UserID: \(self.userId ?? "no ID")")
                    //load data here
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                       // performSegue(withIdentifier: "moveToTabVC", sender: nil)
                        moveToLFG()
                    }
                }
            }
        }
    }
    
//    func createContactList() {
//        let contactList: [String] = [""]
//        let contactListOwnerId: String = ""
//    }
    
    func createData() {
        
        let game2: String = ""
        let titleOfGroup2: String = ""
        let groupSize2: String = ""
        let age2: String = ""
        let availability2: String = ""
        let about2: String = ""
        let name2: String = ""
        let email2: String = ""
        let location: String = ""
        let contacts: [String] = [""]
        // let location: String = ""
        // let color2: UIColor = .red
        // let authData: Any?
        //let clientData: Any?
        
        let user = Users(id: currentAuthID!,
                         game: game2,
                         titleOfGroup: titleOfGroup2,
                         groupSize: groupSize2,
                         age: age2,
                         availability: availability2,
                         about: about2,
                         name: name2,
                         email: email2,
                         location: location,
                         contacts: contacts)
        let userRef = self.db.collection("profile")
        userRef.document(String(user.id)).setData(user.dictionary) { err in
            if let err = err {
                print(err)
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
        currentUser?.link(with: credential) {
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
