//
//  FuncUtils.swift
//  Minesweeper
//
//  Created by Hadar Pur on 28/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import Foundation
import UIKit

class FuncUtils: NSObject {
    var mLoadingAlertController : UIAlertController! = nil
    
    public func showToast(msg: String) {
        guard let appWindow = UIApplication.shared.keyWindow else { fatalError("cannot use keyWindow") }
        
        let label = PaddingLabel()
        label.frame = CGRect(x: 0,y: appWindow.frame.height-100, width: appWindow.frame.width-50, height: 0)
        label.text = msg
        label.textAlignment = .center
        label.sizeToFit()
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        label.numberOfLines = 2
        label.alpha = 1.0
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.frame.origin.x = (appWindow.frame.width/2) - (label.frame.width/2)
        appWindow.addSubview(label)
        
        UIView.animate(withDuration: 2.0, delay: 0.2, options: .curveEaseOut, animations: {
            label.alpha = 0.0
        }) { (isComplete) in
            label.removeFromSuperview()
        }
    }
    
    public func showAlertActivityIndicator(viewController: UIViewController,msg: String) {
        self.mLoadingAlertController = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.mLoadingAlertController.view.addSubview(activityIndicator)
        let xConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.mLoadingAlertController.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.mLoadingAlertController.view, attribute: .centerY, multiplier: 1.4, constant: 0)
        NSLayoutConstraint.activate([ xConstraint, yConstraint])
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.mLoadingAlertController.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)
        self.mLoadingAlertController.view.addConstraint(height);
        viewController.present(self.mLoadingAlertController, animated: true, completion: nil)
    }
    
    public func hideAlertActivityIndicator(viewController: UIViewController) {
        viewController.dismiss(animated: false, completion: nil)
    }
}
