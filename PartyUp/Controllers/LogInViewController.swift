//
//  LogInViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    @IBOutlet var createAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        
        let tabController = storyboard?.instantiateViewController(withIdentifier: "TabController") as! TabController
        
        present(tabController, animated: true, completion:  nil)
        
    }
    
}
