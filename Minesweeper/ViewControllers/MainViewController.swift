//
//  ViewController.swift
//  Minesweeper
//
//  Created by Hadar Pur on 04/09/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import UIKit
import GoogleMaps

class MainViewController: UIViewController {
    var firstAsk = true
    var mGameViewController: GameViewController?
    var firstShow: Bool = true
    let locationManager = CLLocationManager()
    @IBOutlet weak var mEazyBtn: UIButton!
    @IBOutlet weak var mNormalBtn: UIButton!
    @IBOutlet weak var mHardBtn: UIButton!
    @IBOutlet weak var mRecordsBtn: UIButton!
    @IBOutlet weak var mInstructionBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        enableAllBtns();
        if (firstShow) {
            mEazyBtn.center.x  -= view.bounds.width
            mNormalBtn.center.x  -= view.bounds.width
            mHardBtn.center.x  -= view.bounds.width
            mRecordsBtn.center.x  -= view.bounds.width
            mInstructionBtn.center.x  -= view.bounds.width
        } else {
            mEazyBtn.center.x  += view.bounds.width
            mNormalBtn.center.x  += view.bounds.width
            mHardBtn.center.x  += view.bounds.width
            mRecordsBtn.center.x  += view.bounds.width
            mInstructionBtn.center.x  += view.bounds.width
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.5, delay: 0.05, options: [], animations: {
            if (self.firstShow) {
                self.mEazyBtn.center.x  += self.view.bounds.width
            } else{
                self.mEazyBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: {
            if (self.firstShow) {
                self.mNormalBtn.center.x  += self.view.bounds.width
            } else{
                self.mNormalBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.15, options: [], animations: {
           if (self.firstShow) {
                self.mHardBtn.center.x  += self.view.bounds.width
           } else{
                self.mHardBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [],animations: {
            if (self.firstShow) {
                self.mRecordsBtn.center.x  += self.view.bounds.width
            } else{
                self.mRecordsBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.25, options: [],animations: {
            if (self.firstShow) {
                self.mInstructionBtn.center.x  += self.view.bounds.width
            } else{
                self.mInstructionBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        
        firstShow = false
    }

    func enableAllBtns() {
        mEazyBtn.isEnabled = true
        mNormalBtn.isEnabled = true
        mHardBtn.isEnabled = true
        mRecordsBtn.isEnabled = true
        mInstructionBtn.isEnabled = true
    }
    
    func unableAllBtns() {
        mEazyBtn.isEnabled = false
        mNormalBtn.isEnabled = false
        mHardBtn.isEnabled = false
        mRecordsBtn.isEnabled = false
        mInstructionBtn.isEnabled = false
    }
    
    // MARK: Actions
    @IBAction func eazyLevelBtn(_ sender: UIButton) {
        unableAllBtns();
        
        sender.touch()
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.mGameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        
        guard self.mGameViewController != nil else {
            return
        }
        
        self.mGameViewController!.mDiff = 0
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.navigationController?.pushViewController(self.mGameViewController!, animated: true)
        })
    }
    
    @IBAction func normalLevelBtn(_ sender: UIButton) {
        unableAllBtns();
        
        sender.touch()
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.mGameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        
        guard self.mGameViewController != nil else {
            return
        }
        
        self.mGameViewController!.mDiff = 1

        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.navigationController?.pushViewController(self.mGameViewController!, animated: true)
        })
    }
    
    @IBAction func hardLevelBtn(_ sender: UIButton) {
        unableAllBtns();
        
        sender.touch()
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.mGameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        
        guard self.mGameViewController != nil else {
            return
        }
        
        self.mGameViewController!.mDiff = 2
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.navigationController?.pushViewController(self.mGameViewController!, animated: true)
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
    
    @IBAction func instructionsBtn(_ sender: UIButton) {
        unableAllBtns();
        
        sender.touch()
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let instrucionsViewController = storyBoard.instantiateViewController(withIdentifier: "InstructionsViewController") as? InstructionsViewController
        
        guard instrucionsViewController != nil else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.navigationController?.pushViewController(instrucionsViewController!, animated: true)
        })
    }
}

// extension for map view
extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
    }
}
