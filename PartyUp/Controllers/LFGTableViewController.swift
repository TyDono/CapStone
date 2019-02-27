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
import FirebaseFirestore
import FirebaseAuth

class LFGTableViewController: UITableViewController {
    
    //basic info outlets
    @IBOutlet var searchGame: UITextField!
    @IBOutlet var searchAge: UITextField!
    @IBOutlet var groupSizeNumber: UILabel!
    @IBOutlet var distanceSegmentation: UISegmentedControl!
    @IBOutlet var searchOutlet: UIButton!
    @IBOutlet var logOut: UIBarButtonItem!
    
    //variables
    var db: Firestore!
    var currentUser: User?
    var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        checkLoacationServices()
//        searchGame.delegate = self
//        searchAge.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        
        //search
//        db.collection("profile").whereField("game", isEqualTo: searchAge.text).getDocuments { (snapshop, error) in
//            if error != nil {
//                print(error)
//            } else {
//                for document in (snapshop?.documents)! {
//                    if let name = document.data()["game"] as? String {
//                        print("got games")
//                    }
//                }
//            }
//        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchAge.resignFirstResponder()
    }
    
    ///LOCATION MAPKIT
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000.0
    
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
    
    //basicInfoActions
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        if searchGame.text == "" {
            print("not ok")
            searchGame.backgroundColor = .yellow
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

//ACTIONS
@IBAction func groupSizeTapped(sender: UIStepper) {
    groupSizeNumber.text = String(sender.value)
}
    
    @IBAction func logOutTapped(sender: UIBarButtonItem) {
        print("Logged Out")
        self.currentUser = nil
        self.userId = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            moveToLogIn()
        }
    }

}

//EXTENSIONS
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
