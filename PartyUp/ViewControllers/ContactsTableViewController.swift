//
//  ContactsTableViewController.swift
//  PartyUp
//
//  Created by Tyler Donohue on 2/27/20.
//  Copyright © 2020 Tyler Donohue. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

class ContactsTableViewController: UITableViewController {
    
    @IBOutlet var reportChatPopOver: UIView!
        @IBOutlet weak var reportCommentsTextView: UITextView!
    
    // MARK: - Propeties
    var contactListId = [String?]()
    var contactsName = [String?]()
    var cellIsHidden: Bool? = false
    var cog: Bool? = true
    var currentAuthID = Auth.auth().currentUser?.uid
    var db: Firestore!
    var currentUserName: String?
    var chatId: String?
    var currentDate: String?
    var userReportedId: String?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        changeBackground()
        DispatchQueue.main.async {
            self.getPersonalData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListId.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactsTableViewCell else { return UITableViewCell() } // not getting called
        if contactListId.count == 0 {
            return cell
        } else {
            let contactId = contactListId[indexPath.row]
            let contactName = contactsName[indexPath.row]//will crash if comes as nothing
            if contactId == "" {
                cell.isHidden = true
                self.cellIsHidden = true
            }
            self.chatId = contactId
            cell.contactId = contactId
            cell.contactNameLabel.text = contactName
            return cell
        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        var rowHeight:CGFloat = 75.0
//        if self.cellIsHidden == true {
//            indexPath.row == 1 ? (rowHeight = 0.0): (rowHeight = 75.0)
//        }
//        return rowHeight
//    }
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMessages", let messagesTVC = segue.destination as? ChatLogViewController {
            if let row = self.tableView.indexPathForSelectedRow?.row, let contactId = contactListId[row] {
                messagesTVC.chatId = contactId
                messagesTVC.currentUserName = self.currentUserName
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToMessages", sender: self)
    }
    
    // MARK: - Functions
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.tableView.backgroundView = backgroundImage
    }
    
    func getPersonalData() {
        guard let uid: String = self.currentAuthID else { return }
        let profileRef = self.db.collection("profile").whereField("id", isEqualTo: uid)
        profileRef.getDocuments { (snapshot, error) in
            if error != nil {
                print(error as Any)
            } else {
                for document in (snapshot?.documents)! {
                    guard let contactList = document.data()["contactsId"] as? [String],
                        let name = document.data()["name"] as? String,
                        let contactName = document.data()["contactsName"] as? [String] else { return }
                    self.contactListId = contactList
                    self.contactsName = contactName
                    self.currentUserName = name
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getCurrentDate() {
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "d/M/yy"
        let myDate : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        self.currentDate = myDate
    }
    
    func showPopOverAnimate() {
        self.reportChatPopOver.center = self.view.center
        self.reportChatPopOver.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.reportChatPopOver.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.reportChatPopOver.alpha = 1.0
            self.reportChatPopOver.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removePopOverAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.reportChatPopOver.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.reportChatPopOver.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished) {
                    self.reportChatPopOver.removeFromSuperview()
                }
        });
    }
    
    func createReportData() {
        getCurrentDate()
        guard let creatorId = self.currentAuthID,
            let reason = reportCommentsTextView.text,
            let chatId = self.chatId,
            let userReportedId = self.userReportedId,
            let dateSent = self.currentDate else { return }
        let userReportUID: String = UUID().uuidString
        let userReport = UserReport(reason: reason,
                                    creatorId: creatorId,
                                    chatId: chatId,
                                    dateSent: dateSent,
                                    reportId: userReportUID,
                                    userReportedId: userReportedId)
        let userReportRef = self.db.collection("userReports")
        userReportRef.document(userReportUID).setData(userReport.dictionary) { err in
            if let err = err {
                let reportChatFailAlert = UIAlertController(title: "Failed to report", message: "Your device failed to correctly send the report. Please make sure you have a stable internet connection.", preferredStyle: .alert)
                let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
                reportChatFailAlert.addAction(dismiss)
                self.present(reportChatFailAlert, animated: true, completion: nil)
                print(err)
            } else {
                let reportChatAlertSucceed = UIAlertController(title: "Thank you!", message: "Your report has been received, thank you for your report", preferredStyle: .alert)
                let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
                reportChatAlertSucceed.addAction(dismiss)
                self.removePopOverAnimate()
                self.present(reportChatAlertSucceed, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func reportChatButtonTapped(_ sender: Any) {
        self.view.addSubview(reportChatPopOver)
        showPopOverAnimate()
    }
    
    @IBAction func cancelReportButtonTapped(_ sender: Any) {
        removePopOverAnimate()
    }
    
    @IBAction func submitReportButtonTapped(_ sender: UIButton) {
        createReportData()
    }
    
    @IBAction func unwindToContacts(_ sender: UIStoryboardSegue) {}

}
