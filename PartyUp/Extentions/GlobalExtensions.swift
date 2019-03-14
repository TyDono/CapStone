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

//ranime user name gen
extension String {
    static var randomName: String {
        let adjectives = ["autumn", "hidden", "bitter", "misty", "silent", "empty", "dry", "dark", "summer", "icy", "delicate", "quiet", "white", "cool", "spring", "winter", "patient", "twilight", "dawn", "crimson", "wispy", "weathered", "blue", "billowing", "broken", "cold", "damp", "falling", "frosty", "green", "long", "late", "lingering", "bold", "little", "morning", "muddy", "old", "red", "rough", "still", "small", "sparkling", "throbbing", "shy", "wandering", "withered", "wild", "black", "young", "holy", "solitary", "fragrant", "aged", "snowy", "proud", "floral", "restless", "divine", "polished", "ancient", "purple", "lively", "nameless", "pasta"]
        let nouns = ["waterfall", "river", "breeze", "moon", "rain", "wind", "sea", "morning", "snow", "lake", "sunset", "pine", "shadow", "leaf", "dawn", "glitter", "forest", "hill", "cloud", "meadow", "sun", "glade", "bird", "brook", "butterfly", "bush", "dew", "dust", "field", "fire", "flower", "firefly", "feather", "grass", "haze", "mountain", "night", "pond", "darkness", "snowflake", "silence", "sound", "sky", "shape", "surf", "thunder", "violet", "water", "wildflower", "wave", "water", "resonance", "sun", "wood", "dream", "cherry", "tree", "fog", "frost", "voice", "paper", "frog", "smoke", "star", "pasta"]
        
        return adjectives.randomElement()! + nouns.randomElement()!
    }
}

//random color gen
extension UIColor {
    static var randomColor: UIColor {
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1)
    }
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
