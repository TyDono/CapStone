//
//  GlobalExtensions.swift
//  PartyUp
//
//  Created by Tyler Donohue on 2/26/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import AVKit

// moveTo funcs will do as intedned. have the user move to what ever the VC it has as its destiantion
func moveToLFG() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
    appDelegate.window?.makeKeyAndVisible()
    let destinationVC = TabController()
    
    destinationVC.selectedIndex = 1
    let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
    let tabController = storyboard.instantiateViewController(withIdentifier: "lfg")
    appDelegate.window?.rootViewController = tabController
}

func moveToLogIn() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
    appDelegate.window?.makeKeyAndVisible()
    
    let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
    let loginVC = storyboard.instantiateViewController(withIdentifier: "login")
    appDelegate.window?.rootViewController = loginVC
}

func moveToMessages() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
    appDelegate.window?.makeKeyAndVisible()
    
    let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
    let messagesVC = storyboard.instantiateViewController(withIdentifier: "chatLogs")
    appDelegate.window?.rootViewController = messagesVC
}

//randome user name gen
//extension String {
//    static var randomName: String {
//        let adjectives = ["ravioli", "cavatelli", "ziti", "vermicelli", "manicotti", "paccheri", "dry", "dark", "farfalle", "icy", "delicate", "quiet", "white", "cool", "spring", "winter", "patient", "twilight", "dawn", "crimson", "wispy", "weathered", "blue", "billowing", "broken", "cold", "damp", "falling", "frosty", "green", "fusilli", "late", "lingering", "bold", "little", "morning", "muddy", "old", "red", "rough", "still", "small", "sparkling", "throbbing", "shy", "agnolotti", "withered", "wild", "penne", "young", "holy", "liguine", "fragrant", "aged", "snowy", "proud", "rigatoni", "pappardelle", "divine", "capellini", "ancient", "purple", "macaroni", "spaghetti", "pasta"]
//        let nouns = ["farfalle", "agnolotti", "vermicelli", "moon", "fusilli", "wind", "sea", "morning", "snow", "lake", "sunset", "pine", "shadow", "leaf", "penne", "glitter", "forest", "hill", "cloud", "orzo", "sun", "rotini", "bird", "ziti", "butterfly", "bush", "dew", "dust", "field", "fire", "flower", "firefly", "feather", "grass", "haze", "mountain", "night", "pond", "darkness", "manicotti", "pappardelle", "sound", "capellini", "shape", "surf", "thunder", "violet", "water", "wildflower", "cavatelli", "water", "resonance", "sun", "wood", "dream", "cherry", "rigatoni", "fog", "macaroni", "ravioli", "paper", "liguine", "smoke", "spaghetti", "pasta"]
//
//        return adjectives.randomElement()! + nouns.randomElement()!
//    }
//}

extension UIColor {
    convenience init(_ r: Double,_ g: Double,_ b: Double,_ a: Double) {
        self.init(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(a))
    }
}

extension UIFont {
    var bold: UIFont {
        return with(.traitBold)
    }
    var italic: UIFont {
        return with(.traitItalic)
    }
    var boldItalic: UIFont {
        return with([.traitBold, .traitItalic])
    }

    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}

extension UITextField {
    func isError(baseColor: CGColor, numberOfShakes shakes: Float, revert: Bool) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
        animation.fromValue = baseColor
        animation.toValue = UIColor.red.cgColor
        animation.duration = 0.4
        if revert { animation.autoreverses = true } else { animation.autoreverses = false }
        self.layer.add(animation, forKey: "")
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(shake, forKey: "position")
    }
    
    func setBottomBorderOnlyWith(color: CGColor) {
        self.borderStyle = .none
        self.layer.masksToBounds = false
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension AVAsset {
    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
extension UIButton {
    func pulsate() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.4
    pulse.fromValue = 0.98
    pulse.toValue = 1.0
    pulse.autoreverses = true
    pulse.repeatCount = .infinity
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0
    layer.add(pulse, forKey: nil)
    }

}

//scrollview constraints
extension UIScrollView {
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
}
