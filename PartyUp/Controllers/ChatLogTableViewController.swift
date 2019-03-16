//
//  ChatLogTableViewController.swift
//  PartyUp
//
//  Created by Tyler Donohue on 3/15/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit

class ChatLogTableViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInputComponents()
        
    }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.blue
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
    }

}
