//
//  ButtonExtentions.swift
//  Minesweeper
//
//  Created by Hadar Pur on 26/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func touch() {
        let touch = CABasicAnimation(keyPath: "position")
        touch.duration = 0.1
        touch.repeatCount = 2
        touch.autoreverses = true

        let fromPoint = CGPoint(x: center.x-5, y: center.y)
        let toPoint = CGPoint(x: center.x+5, y: center.y)
        
        touch.fromValue = NSValue(cgPoint: fromPoint)
        touch.toValue = NSValue(cgPoint: toPoint)
        touch.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        layer.add(touch, forKey: nil)
    }
    
    func rotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Float(.pi * 2.0)
        rotationAnimation.duration = 1
        
        layer.add(rotationAnimation, forKey: nil)
    }
}
