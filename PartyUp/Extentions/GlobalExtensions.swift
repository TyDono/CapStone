//
//  GlobalExtensions.swift
//  PartyUp
//
//  Created by Tyler Donohue on 2/26/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

func moveToLFG() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
    appDelegate.window?.makeKeyAndVisible()
    let destinationVC = TabController()
    
    destinationVC.selectedIndex = 1
    let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
    let tabController = storyboard.instantiateViewController(withIdentifier: "lfg")
    appDelegate.window?.rootViewController = tabController
}

func moveToLogIn() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
    appDelegate.window?.makeKeyAndVisible()
    let destinationVC = LogInViewController()
    
    let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
    let loginVC = storyboard.instantiateViewController(withIdentifier: "login")
    appDelegate.window?.rootViewController = loginVC
}

func createData() {
    
    Firestore.firestore().collection("Profile").addDocument(data: [
        "game": "",
        "title of group": "",
        "age": 0,
        // experiance
        "group size": "",
        "availability": "",
        "about": ""
    ]) { (error) in
        if let error = error {
        print(error)
    } else {
        print("Added Data to Firestore")
        }
    }
}
