//
//  ResultViewController.swift
//  Minesweeper
//
//  Created by Hadar Pur on 18/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    let mWinningImage = UIImage(named: "winning.png") as UIImage?
    let mLossingImage = UIImage(named: "lose.png") as UIImage?
    var mStatus: Bool?
    var mState: Bool?
    var mLatitude: Double?, mLongitude: Double?
    var mResults: Int?, mPoints: Int?, mLevel: Int?
    @IBOutlet weak var mStatusImageView: UIImageView!
    @IBOutlet weak var mRecordBtn: UIButton!
    @IBOutlet weak var mNewGameBtn: UIButton!
    @IBOutlet weak var mHomeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusImage()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableAllBtns();
    }

    func setStatusImage() {
        if self.mStatus {
            self.mStatusImageView.image = mLossingImage
        }
        else {
            self.mStatusImageView.image = mWinningImage
            if self.mState {
                var navigationArray = self.navigationController?.viewControllers //To get all UIViewController stack as Array
                navigationArray!.remove(at: (navigationArray?.count)! - 2) // To remove previous UIViewController
                self.navigationController?.viewControllers = navigationArray!
            }
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            print("Swipe Right")
            _=self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func homePageBtn(_ sender: UIButton) {
        unableAllBtns();
        sender.touch()
        var navigationArray = self.navigationController?.viewControllers //To get all UIViewController stack as Array
        navigationArray!.remove(at: (navigationArray?.count)! - 2) // To remove previous UIViewController
        self.navigationController?.viewControllers = navigationArray!
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            _=self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func newGameBtn(_ sender: UIButton) {
        unableAllBtns();
        sender.touch()
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            _=self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func recordsBtn(_ sender: UIButton) {
        unableAllBtns();
        
        sender.touch()
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let recordsViewController = storyBoard.instantiateViewController(withIdentifier: "RecordsViewController") as? RecordsViewController
        
        guard recordsViewController != nil else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.navigationController?.pushViewController(recordsViewController!, animated: true)
        })
    }
    
    func unableAllBtns() {
        self.mRecordBtn.isEnabled = false
        self.mNewGameBtn.isEnabled = false
        self.mHomeBtn.isEnabled = false
    }
    
    func enableAllBtns() {
        self.mRecordBtn.isEnabled = true
        self.mNewGameBtn.isEnabled = true
        self.mHomeBtn.isEnabled = true
    }
}
