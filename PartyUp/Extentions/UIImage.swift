//
//  AppDelegate+GoogleSignIn.swift
//  PartyUp
//
//  Created by Tyler Donohue on 2/26/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

//used when i have forebasestorage unstood for profile iamges
extension UIImage {
  
  var scaledToSafeUploadSize: UIImage? {
    let maxImageSideLength: CGFloat = 480
    
    let largerSide: CGFloat = max(size.width, size.height)
    let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
    let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
    
    return image(scaledTo: newImageSize)
  }
  
  func image(scaledTo size: CGSize) -> UIImage? {
    defer {
      UIGraphicsEndImageContext()
    }
    
    UIGraphicsBeginImageContextWithOptions(size, true, 0)
    draw(in: CGRect(origin: .zero, size: size))

    return UIGraphicsGetImageFromCurrentImageContext()
  }
  
}
