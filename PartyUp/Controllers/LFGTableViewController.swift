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
    @IBOutlet var distanceSearchSlider: UISlider!
    @IBOutlet var prefGroupSizeSearch: UIStepper!
    @IBOutlet var groupSizeNumber: UILabel!
    @IBOutlet var miles: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func updateView() {
        
    }
    
    //basicInfoActions
    @IBAction func distanceSliderMoved(_ sender: UISlider) {
        
    }
    
    @IBAction func groupSizeTapped(sender: UIStepper) {
        groupSizeNumber.text = String(sender.value)
    }
    
}
