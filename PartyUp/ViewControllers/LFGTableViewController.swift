//
//  LFGTableViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreLocation
import GoogleSignIn
import FirebaseFirestore
import FirebaseAuth

// I have shrunk the amount of tools they have to use a search to make it more simple since users I will have less users to start and dont want to inhibit
class LFGTableViewController: UITableViewController {
    
    //MARK OUTLETS
    @IBOutlet var searchGame: UITextField!
    @IBOutlet var distanceSegmentation: UISegmentedControl!
    @IBOutlet var logOut: UIBarButtonItem!
    @IBOutlet var groupSize: UITextField!
    
    //MARK VARIABLES
    var db: Firestore!
    var currentUser: User?
    var userId: String = ""
    static let sharedController = LFGTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        checkLoacationServices()
        searchGame.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        changeBackground()
        
    }
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.tableView.backgroundView = backgroundImage
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchGame.resignFirstResponder()
    }
    
    ///LOCATION MAPKIT
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 100000.0
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLoacationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLoacationAuthorization()
            
        } else {
            // an alert for location, when appple doesnt handle it
            let locationAlert = UIAlertController(title: "Location not on", message: "Turn on Locations Services to allow Party Up to determine your location", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            locationAlert.addAction(cancelAction)
            
            let goToSettingsAction = UIAlertAction(title: "Settings", style: .default, handler: { action in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
                locationAlert.addAction(goToSettingsAction)
            present(locationAlert, animated: true, completion: nil)
        }
    }
    
    func checkLoacationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    
    // MARK: - Actions
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        // if requirements to search are not met
        if searchGame.text == "" {
            print("not ok")
//            UIView.animate(withDuration: 0.01) {
//                self.searchGame.backgroundColor = .yellow
//            }
//            UIView.animate(withDuration: 5.0) {
//                self.searchGame.backgroundColor = .white
//            }
            UIView.animate(withDuration: 0.09, animations: {
                let move = CGAffineTransform(translationX: 10, y: 0)
                self.searchGame.transform = move
            }) { (_) in
                UIView.animate(withDuration: 0.09, animations: {
                    self.searchGame.transform = .identity
                })
            }
        } else {
            print("ok")
            
            performSegue(withIdentifier: "segueSearch", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueSearch", let searchResultsVC = segue.destination as? SearchResultsTableViewController {
            
            searchResultsVC.text = searchGame.text
        }
        print("prepare for segueSearch called")
    }
    
    @IBAction func logOutTapped(sender: UIBarButtonItem) {
        print("Logged Out")
        self.currentUser = nil
        self.userId = ""
        try! Auth.auth().signOut()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            moveToLogIn()
        }
    }
}

//MARK EXTENSIONS
extension LFGTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// location extension
extension LFGTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude:location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLoacationAuthorization()
    }
    
}
