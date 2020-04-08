//
//  LFGViewController.swift
//  PartyUp
//
//  Created by Tyler Donohue on 3/3/20.
//  Copyright © 2020 Tyler Donohue. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreLocation
import FirebaseFirestore
import FirebaseAuth
import AVFoundation

class LFGViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableViewGameList: UITableView!
    @IBOutlet var searchGame: UITextField!
    @IBOutlet var logOut: UIBarButtonItem!
    
    // MARK: - Propeties
    
//    var gameList: [Games]?
    var games: [String] = Array() //Games.name // ["jim", "jam", "joom"]
    var gameList: [String] = Array()
    var db: Firestore!
    var currentUser: User?
    var userId: String = ""
    var audioPlayer = AVAudioPlayer()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        games.append("jim")
        games.append("tim")
        games.append("slim")
        for game in games {
            gameList.append(game)
        }
        db = Firestore.firestore()
        tableViewGameList.delegate = self
        tableViewGameList.dataSource = self
        searchGame.delegate = self
        PaperSound()
        searchGame.delegate = self as? UITextFieldDelegate
//        checkLoacationServices()
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        locationManager.distanceFilter = 100
        changeBackground()
        searchGame.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
        hideTableview()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           searchGame.resignFirstResponder()
           return true
       }
    
    @objc func searchRecords(_ textField: UITextField) {
        self.games.removeAll()
        if textField.text?.count != 0 {
            tableViewGameList.isHidden = false
            for game in gameList {
                guard let gameToSearch = textField.text else { return }
                let range = game.lowercased().range(of: gameToSearch, options: .caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    self.games.append(game)
                }
            }
        } else {
            for game in gameList {
                games.append(game)
            }
        }
        tableViewGameList.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchGame.resignFirstResponder()
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gamesCell", for: indexPath) as? GamesListTableViewCell else { return UITableViewCell() }
        tableView.rowHeight = 60
        //        if let gameList = gameList {
        let game = games[indexPath.row]
        cell.selectionStyle = .none
        cell.GameNameLabel.text = game
        //        }
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let row = self.tableViewGameList.indexPathForSelectedRow?.row {
            let gameName = games[row]
            searchGame.text = gameName
        }
    }
    
    // MARK: - Functions
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "NewRealisticBillboard")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func PaperSound() {
        let paperSound = Bundle.main.path(forResource: "paperBookSound", ofType: "wav")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: paperSound!))
        }
        catch {
            print(error)
        }
    }
    
    func hideTableview() {
        if searchGame.text?.count == 0 {
            tableViewGameList.isHidden = true
        }
    }
    
    func showTableview() {
        if searchGame.text?.count != 0 {
            tableViewGameList.isHidden = false
        }
    }
    
    ///LOCATION MAPKIT
//    let locationManager = CLLocationManager()
//    let regionInMeters: Double = 100000.0
//
//    func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
    
//    func checkLoacationServices() {
//        if CLLocationManager.locationServicesEnabled() {
//            setupLocationManager()
//            checkLoacationAuthorization()
//
//        } else {
//            // an alert for location, when appple doesnt handle it
//            let locationAlert = UIAlertController(title: "Location not on", message: "Turn on Locations Services to allow Party Up to determine your location", preferredStyle: .actionSheet)
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            locationAlert.addAction(cancelAction)
//
//            let goToSettingsAction = UIAlertAction(title: "Settings", style: .default, handler: { action in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//            })
//            locationAlert.addAction(goToSettingsAction)
//            present(locationAlert, animated: true, completion: nil)
//        }
//    }
    
//    func checkLoacationAuthorization() {
//        switch CLLocationManager.authorizationStatus() {
//        case .authorizedWhenInUse:
//
//            break
//        case .denied:
//            break
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//            break
//        case .restricted:
//            break
//        case .authorizedAlways:
//            break
//        }
//    }
    
    // MARK: - Actions
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        // if requirements to search are not met
        if searchGame.text == "" {
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
            audioPlayer.play()
            performSegue(withIdentifier: "segueSearch", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueSearch", let searchResultsVC = segue.destination as? SearchResultsTableViewController {
            searchResultsVC.text = searchGame.text
        }
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

////MARK EXTENSIONS
//extension LFGTableViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
//
//// location extension
//extension LFGTableViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        let center = CLLocationCoordinate2D(latitude:location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        checkLoacationAuthorization()
//    }
    
}
