//
//  AppDelegate+GoogleSignIn.swift
//  PartyUp
//
//  Created by Tyler Donohue on 2/26/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

extension AppDelegate {
    func sign(_ signIn: GIDSignIn!,
              didSignInFor user: GIDGoogleUser!,
              withEror error: Error?) {
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        guard MyFirebase.shared.currentUser != nil else {
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error)
                    return
                }
            }
            return
        }
    }
    func sign(_ signIn: GIDSignIn!,
              didDissconnectWith user: GIDGoogleUser!,
               withError error: Error!) {
        // perform any operations when the user dissconects from the app here
    }
}
