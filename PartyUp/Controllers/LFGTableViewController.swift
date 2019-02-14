//
//  LFGTableViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit

class LFGTableViewController: UITableViewController {
    
    //basic info outlets
    @IBOutlet var searchGame: UITextField!
    @IBOutlet var searchAge: UITextField!
    @IBOutlet var searchExperience: UITextField!
    @IBOutlet var groupSizeNumber: UILabel!
    @IBOutlet var distanceSegmentation: UISegmentedControl!
    @IBOutlet var searchOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchGame.delegate = self
        
    }
    
    func updateView() {
        
    }
    
    //basicInfoActions
    @IBAction func searchButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func groupSizeTapped(sender: UIStepper) {
        groupSizeNumber.text = String(sender.value)
    }
    
}

extension LFGTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}
