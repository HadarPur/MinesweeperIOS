//
//  InstructionsViewController.swift
//  Minesweeper
//
//  Created by Hadar Pur on 21/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    // outlet
    @IBOutlet weak var mTextViewField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mTextViewField.setContentOffset(CGPoint.zero, animated: false)
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            print("Swipe Right")
            _=self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
}
