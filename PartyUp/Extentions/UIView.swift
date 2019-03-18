//
//  AppDelegate+GoogleSignIn.swift
//  PartyUp
//
//  Created by Tyler Donohue on 2/26/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit

extension UIView {
  
  func smoothRoundCorners(to radius: CGFloat) {
    let maskLayer = CAShapeLayer()
    maskLayer.path = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: radius
    ).cgPath
    
    layer.mask = maskLayer
  }
  
}
