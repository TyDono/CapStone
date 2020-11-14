//
//  LogInViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore
import Firebase
import AuthenticationServices
import CryptoKit
import WebKit

protocol LogInViewControllerDelegate {
    func didFinishAuth()
}

//@available(iOS 13.0, *)
class LogInViewController: UIViewController, WKUIDelegate, GIDSignInDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var createAccount: UIButton!
    @IBOutlet weak var signInWithappleButton: UIButton!
    
    // MARK: - Propeties
    
    var db: Firestore!
    var userId: String = ""
    let userDefault = UserDefaults.standard
    var delegate: LogInViewControllerDelegate?
    fileprivate var currentNonce: String?
    
    //    @available(iOS 13.0, *)
    //    lazy var appleLogInButton: ASAuthorizationAppleIDButton = {
    //        let button = ASAuthorizationAppleIDButton()
    //        button.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    //        return button
    //    }()
    
    //    @available(iOS 13.0, *) removed due to objc not working?
    //    @objc func appleLoginButtonTapped() {
    //        let request = ASAuthorizationAppleIDProvider().createRequest()
    //        request.requestedScopes = [.fullName, .email]
    //        let controller = ASAuthorizationController(authorizationRequests: [request])
    //        controller.delegate = self
    //        controller.presentationContextProvider = self
    //        controller.performRequests()
    //    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().signIn()
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
//        GIDSignIn.sharedInstance()?.uiDelegate = self
        db = Firestore.firestore()
        changeBackground()
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "segueToSearch", sender: nil)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "userSignedIn") {
            performSegue(withIdentifier: "segueToSearch", sender: self)
        }
    }
    
    // MARK: - Functions

func chageTextColor() {
    navigationItem.leftBarButtonItem?.tintColor = UIColor(0.0, 128.0, 128.0, 1.0)
    navigationItem.rightBarButtonItem?.tintColor = UIColor(0.0, 128.0, 128.0, 1.0)
}

func changeBackground() {
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    backgroundImage.image = UIImage(named: "newwizard")
    backgroundImage.contentMode = .scaleToFill
    self.view.insertSubview(backgroundImage, at: 0)
}

func whiteStatusBar() -> UIStatusBarStyle{
    return UIStatusBarStyle.lightContent
}

func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    if let error = error {
        print("\(error.localizedDescription)")
        return
    } else {
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (result, error) in
            if error == nil {
            } else {
                print(error?.localizedDescription)
            }
        }
    }
}

// MARK: - Apple Sign In

// makes the nonce
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

// Unhashed nonce.
@available(iOS 13, *)
func startSignInWithAppleFlow() {
    let nonce = randomNonceString()
    currentNonce = nonce
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = sha256(nonce)
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
}

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

func HideAppleButton() {
    if #available(iOS 13.0, *) {
        signInWithappleButton.isHidden = false
    } else {
        signInWithappleButton.isHidden = true
    }
}

// MARK: - Actions

@IBAction func googleSignInButtonWasTapped(_ sender: UIButton) {
    GIDSignIn.sharedInstance()?.delegate = self
    GIDSignIn.sharedInstance()?.signIn()
}

@IBAction func appleSigninButtonWasTapped(_ sender: UIButton) {
    if #available(iOS 13.0, *) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        startSignInWithAppleFlow()
    }
    
}

@IBAction func cancelSignUpButtonTapped(_ sender: UIBarButtonItem) {
    
}

@IBOutlet weak var signInButton: GIDSignInButton!

@IBAction func logout(_ sender: UIBarButtonItem) {
    GIDSignIn.sharedInstance().signOut()
    self.userId = ""
    try! Auth.auth().signOut()
}

@IBAction func unwindToSignIn(_ sender: UIStoryboardSegue) {}

}

@available(iOS 13.0, *)
extension LogInViewController: ASAuthorizationControllerDelegate {
    
    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
        //sign in with new account
        delegate?.didFinishAuth()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func SignInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
        // sign in with existing user
        delegate?.didFinishAuth()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func SignInWithUserAndPassword(credentail: ASPasswordCredential) {
        //sign in using existing icloud keychain
        delegate?.didFinishAuth()
        self.dismiss(animated: true, completion: nil)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIdCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure you're sending the SHA256-hashed nonce as a hex string with your request to Apple.
                    print("Error:", error)
                    return
                }
                guard let currentUser = Auth.auth().currentUser else {return}
                currentUser.reauthenticate(with: credential) { (authResult, error) in
                    guard error != nil else { return }
                    // Apple user successfully re-authenticated.
                }
                // User is signed in to Firebase with Apple.
            }
            
            let userId = appleIdCredential.user
            UserDefaults.standard.set(userId, forKey: SignInWithAppleManager.userIdentifierKey)
            if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
                registerNewAccount(credential: appleIdCredential)
                //test create user here?
            } else {
                SignInWithExistingAccount(credential: appleIdCredential)
            }
            break
        case let passwordCredential as ASPasswordCredential:
            let userId = passwordCredential.user
            UserDefaults.standard.set(userId, forKey: SignInWithAppleManager.userIdentifierKey)
            SignInWithUserAndPassword(credentail: passwordCredential)
            break
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error:", error)
        //        let alert = UIAlertController(title: "Error", message: "There was an error while trying to sign in, please try again", preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        //            alert.dismiss(animated: true, completion: nil)
        //        }))
        //        self.present(alert, animated: true, completion: nil)
        return
    }
}

@available(iOS 13.0, *)
extension LogInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
