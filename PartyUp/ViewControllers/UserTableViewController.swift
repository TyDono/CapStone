//
//  UserTableViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FirebaseStorage

class UserTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var profileUIImage: UIImageView!
    @IBOutlet var gameTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var yourAgeTextField: UITextField!
    @IBOutlet var availabilityTextField: UITextView!
    @IBOutlet var aboutTextField: UITextView!
    @IBOutlet var groupSizeTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    
    // MARK: - Propeties
    
    var db: Firestore!
    var currentAuthID = Auth.auth().currentUser?.uid
    var currentUser: Users?
    var userId: String?
    var locationSpot: String? = ""
    var contactsName = [""]
    var contactsId = [""]
    var profileImageID: String?
    let storage = Storage.storage()
    var profileImages = [UIImage]()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        changeBackground()
        getPersonalData()
    }
    
    // MARK: - Functions
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Page")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.tableView.backgroundView = backgroundImage
    }
    
    func getPersonalData() {
        guard let uid: String = self.currentAuthID else { return }
        print("this is my uid i really like my uid \(uid)")
        let profileRef = self.db.collection("profile").whereField("id", isEqualTo: uid)
        profileRef.getDocuments { (snapshot, error) in
            if error != nil {
                print(error as Any)
            } else {
                for document in (snapshot?.documents)! {
                    if let game = document.data()["game"] as? String,
                        let name = document.data()["name"] as? String,
                        let groupSize = document.data()["group size"] as? String,
                        let about = document.data()["about"] as? String,
                        let availability = document.data()["availability"] as? String,
                        let yourAge = document.data()["yourAge"] as? String,
                        let title = document.data()["title of group"] as? String,
                        let location = document.data()["location"] as? String,
                        let contactsId = document.data()["contactsId"] as? [String],
                        let contactsName = document.data()["contactsName"] as? [String],
                        let profileImageID = document.data()["profileImageID"] as? String? {
                        
                        self.gameTextField.text = game
                        self.titleTextField.text = title
                        self.yourAgeTextField.text = yourAge
                        self.availabilityTextField.text = availability
                        self.aboutTextField.text = about
                        self.groupSizeTextField.text = groupSize
                        self.nameTextField.text = name
                        self.locationTextField.text = location
                        self.contactsId = contactsId
                        self.contactsName = contactsName
                        self.profileImageID = profileImageID
                        self.getImages()
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToViewAccount", let otherProfileVC = segue.destination as? ViewPersonalAccountTableViewController {
            otherProfileVC.yourGame = self.gameTextField.text ?? ""
            otherProfileVC.yourTitleOfGroup = self.titleTextField.text ?? ""
            otherProfileVC.yourAge = self.yourAgeTextField.text ?? ""
            otherProfileVC.yourGroupSize = self.groupSizeTextField.text ?? ""
            otherProfileVC.yourAvailability = self.availabilityTextField.text
            otherProfileVC.yourAbout = self.aboutTextField.text
            otherProfileVC.yourName = self.nameTextField.text ?? ""
            otherProfileVC.yourLocation = self.locationTextField.text ?? ""
            otherProfileVC.profileImage = self.profileUIImage.image
        } else if segue.identifier == "segueToSettings", let profileSettingsVC = segue.destination as? SettingsViewController {
            profileSettingsVC.imageString = self.profileImageID
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileUIImage.image = selectedImage
            profileImages.append(selectedImage)
            dismiss(animated: true, completion: nil)
            self.profileUIImage.reloadInputViews()
        }
    }
    
    func getImages() {
        guard let imageStringId = self.profileImageID else  { return }
        let storageRef = storage.reference()
        let profileImage = storageRef.child("profileImages/\(imageStringId)")
        profileImage.getData(maxSize: (1024 * 1024), completion: { (data, err) in
            guard let data = data else {return}
            guard let image = UIImage(data: data) else {return}
            self.profileUIImage.image = image
        })
    }
    
    func uploadFirebaseImages(_ image: UIImage, completion: @escaping ((_ url: URL?) -> () )) {
        let storageRef = Storage.storage().reference().child("profileImages/\(self.profileImageID ?? "no Image Found")")
        guard let imageData = image.jpegData(compressionQuality: 0.05) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if error == nil, metaData != nil {
                print("got profile image")
                storageRef.downloadURL(completion: { (url, error) in
                    completion(url)
                })
            } else {
                completion(nil)
            }
        }
    }
    
    func saveImageToFirebase(graveImagesURL: URL, completion: @escaping((_ success: Bool) -> ())) {
        let databaseRef = Firestore.firestore().document("profileImages/\(self.currentAuthID ?? "no image")")
        let userObjectImages = [
            "imageURL": graveImagesURL.absoluteString
        ] as [String:Any]
        databaseRef.setData(userObjectImages) { (error) in
            completion(error == nil)
        }
        print("SaveImageToFirebase has been saved!!!!!")
    }
    
    // MARK: - Actions
    
    @IBAction func settingBarButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueToSettings", sender: nil)
    }
    
    @IBAction func saveProfileTapped(_ sender: Any) {
        if profileUIImage.image != nil {
            for image in profileImages {
                uploadFirebaseImages(image) { (url) in
                    print(url)
                    guard let url = url else { return }
                }
            }
        }
        
        guard let game = gameTextField.text,
            let titleOfGroup = titleTextField.text,
            let groupSize = groupSizeTextField.text,
            let yourAge = yourAgeTextField.text,
            let availability = availabilityTextField.text,
            let about = aboutTextField.text,
            let name = nameTextField.text,
            let location = locationTextField.text,
            let profileImageID = self.profileImageID
        else {
                        let alert = UIAlertController(title: "Error", message: "there was an error while trying to update your account. Make sure all fields are filled in.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return }
        let contactsId = self.contactsId
        let contactsName = self.contactsName
        
        let user = Users(id: currentAuthID!,
                         game: game,
                         titleOfGroup: titleOfGroup,
                         groupSize: groupSize,
                         age: yourAge,
                         availability: availability,
                         about: about,
                         name: name,
                         location: location,
                         contactsId: contactsId,
                         contactsName: contactsName,
                         profileImageID: profileImageID)
        let userRef = self.db.collection("profile")
        
        userRef.document(String(user.id)).updateData(user.dictionary){ err in
            if let err = err {
                let alert1 = UIAlertController(title: "Not Saved", message: "Sorry, there was an error while trying to save your profile. Please try again.", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert1.dismiss(animated: true, completion: nil)
                }))
                self.present(alert1, animated: true, completion: nil)
                print("Issue: saveProfileTapped() has failed")
                print(err)
            } else {
                let alert2 = UIAlertController(title: "Saved", message: "Your profile has been saved", preferredStyle: .alert)
                alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert2.dismiss(animated: true, completion: nil)
                }))
                self.present(alert2, animated: true, completion: nil)
                //self.profileInfo()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                }
            }
        }
    }
    
    @IBAction func changeUIImageButtonTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func loutOutButtonTapped(_ sender: Any) {
        self.currentUser = nil
        self.userId = ""
        try! Auth.auth().signOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            moveToLogIn()
        }
    }
    
    @IBAction func viewAccountButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToViewAccount", sender: nil)
    }
    
}
