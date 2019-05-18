//
//  ViewOtherProfileTableViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import MessageUI

class ViewOtherProfileTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    //MARK Outlets
    @IBOutlet var otherTitleLabel: UILabel!
    @IBOutlet var otherGameLabel: UILabel!
    @IBOutlet var otherAgeLabel: UILabel!
    @IBOutlet var otherGroupSizeLabel: UILabel!
    @IBOutlet var otherExperianceLabel: UILabel!
    @IBOutlet var otherAvailabilityLabel: UILabel!
    @IBOutlet var otherAboutLabel: UILabel!
    @IBOutlet var contactMe: UIButton!
    @IBOutlet var otherUserNameLabel: UILabel!
    @IBOutlet var otherEmailLabel: UILabel!
    
    var users: [Users]?
    var gameValue: String = ""
    var titleValue: String = ""
    var ageValue: String = ""
    var groupSizeValue: String = ""
    var experianceValue: String = ""
    var availabilityValue: String = ""
    var aboutValue: String = ""
    var text: String?
    var nameValue: String = ""
    var emailValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateOtherProfile()
        changeBackground()
    }
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.tableView.backgroundView = backgroundImage
    }
    
    func updateOtherProfile() {
        otherGameLabel.text = "Game: \(gameValue)"
        otherTitleLabel.text = "\(titleValue)"
        otherAgeLabel.text = "Age: \(ageValue)"
        otherGroupSizeLabel.text = "Group Size: \(groupSizeValue)"
        otherExperianceLabel.text = "Experiance: \(experianceValue)"
        otherAboutLabel.text = "\(aboutValue)"
        otherUserNameLabel.text = "User Name: \(nameValue)"
        otherEmailLabel.text = "Email: \(emailValue)"
    }
    
    //MARK Actions, change to bring up and email to email the user
    @IBAction func contactMeTapped(_ sender: Any) {
        let mailComposeViewcontroller = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewcontroller, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setPreferredSendingEmailAddress(emailValue)
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Failed to send email", message: "Your device failed to send the email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
