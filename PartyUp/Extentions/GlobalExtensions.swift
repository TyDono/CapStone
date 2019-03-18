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

// moveTo funcs will do as intedned. have the user move to what ever the VC it has as its destiantion
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
    
    let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
    let loginVC = storyboard.instantiateViewController(withIdentifier: "login")
    appDelegate.window?.rootViewController = loginVC
}

func moveToMessages() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
    appDelegate.window?.makeKeyAndVisible()
    
    let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
    let messagesVC = storyboard.instantiateViewController(withIdentifier: "chatLogs")
    appDelegate.window?.rootViewController = messagesVC
}

//randome user name gen
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

//hexadecimal color codes
extension UIColor {
    convenience init(hex: String) {
        var hex = hex
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        
        let r = (rgb & 0xff0000) >> 16
        let g = (rgb & 0xff00) >> 8
        let b = rgb & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            alpha: 1
        )
    }
    
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "#%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}
