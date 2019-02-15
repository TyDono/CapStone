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
    @IBOutlet var groupSizeNumber: UILabel!
    @IBOutlet var distanceSegmentation: UISegmentedControl!
    @IBOutlet var searchOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchGame.delegate = self
        searchAge.delegate = self

    }
    
    //basicInfoActions
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        if searchGame.text == "" {
            print("not ok")
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
            
            searchGame.backgroundColor = .yellow
            
            performSegue(withIdentifier: "segue", sender: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchAge.resignFirstResponder()
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
