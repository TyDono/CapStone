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

class LFGTableViewController: UITableViewController {
    
    //basic info outlets
    @IBOutlet var searchGame: UITextField!
    @IBOutlet var searchAge: UITextField!
    @IBOutlet var groupSizeNumber: UILabel!
    @IBOutlet var distanceSegmentation: UISegmentedControl!
    @IBOutlet var searchOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchGame.delegate = self
        searchAge.delegate = self

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchAge.resignFirstResponder()
    }
    
      ///LOCATION MAPKIT
    let locationManager = CLLocationManager()
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLoacationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
        } else {
            //show alert to let the user know to turn it on
        }
    }
    
    func checkLoacationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            break
        case .denied:
            break
        case .notDetermined:
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
            UIView.animate(withDuration: 0.3, animations: {
                let move = CGAffineTransform(translationX: 10, y: 0)
                self.searchGame.transform = move
            }) { (_) in
                UIView.animate(withDuration: 0.3, animations: {
                    let moveBack = CGAffineTransform(translationX: -10, y: 0)
                    self.searchGame.transform = moveBack
                })
            }
        } else {
            print("ok")
            
            performSegue(withIdentifier: "segue", sender: nil)
        }
    }
    
    //ACTIONS
    @IBAction func groupSizeTapped(sender: UIStepper) {
        groupSizeNumber.text = String(sender.value)
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
        <#code#>
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        <#code#>
    }
    
}
