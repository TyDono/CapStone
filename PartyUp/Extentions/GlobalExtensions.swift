//
//  GlobalExtensions.swift
//  PartyUp
//
//  Created by Tyler Donohue on 2/26/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import Foundation
import UIKit

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
