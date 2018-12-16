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
    
    let mLocationManager = CLLocationManager()
    var mGameViewController: GameViewController?
    
    var mCurrentLat: Double = 0
    var mCurrentLong: Double = 0
    
    var mFirstAsk = true
    var mFirstShow: Bool?
    var mIsNetworkEnabled: Bool?
    
    // outlet
    @IBOutlet weak var mEazyBtn: UIButton!
    @IBOutlet weak var mNormalBtn: UIButton!
    @IBOutlet weak var mHardBtn: UIButton!
    @IBOutlet weak var mRecordsBtn: UIButton!
    @IBOutlet weak var mInstructionBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableAllBtns()
        
        self.mFirstShow = true
        
        self.mLocationManager.delegate = self
        self.mLocationManager.requestWhenInUseAuthorization()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.mFirstShow! {
            self.mEazyBtn.center.x  -= view.bounds.width
            self.mNormalBtn.center.x  -= view.bounds.width
            self.mHardBtn.center.x  -= view.bounds.width
            self.mRecordsBtn.center.x  -= view.bounds.width
            self.mInstructionBtn.center.x  -= view.bounds.width
        }
        else {
            self.mEazyBtn.center.x  += view.bounds.width
            self.mNormalBtn.center.x  += view.bounds.width
            self.mHardBtn.center.x  += view.bounds.width
            self.mRecordsBtn.center.x  += view.bounds.width
            self.mInstructionBtn.center.x  += view.bounds.width
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
        UIView.animate(withDuration: 0.5, delay: 0.05, options: [], animations: {
            if self.mFirstShow! {
                self.mEazyBtn.center.x  += self.view.bounds.width
            }
            else{
                self.mEazyBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: {
            if self.mFirstShow! {
                self.mNormalBtn.center.x  += self.view.bounds.width
            }
            else{
                self.mNormalBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.15, options: [], animations: {
           if self.mFirstShow! {
                self.mHardBtn.center.x  += self.view.bounds.width
           }
           else{
                self.mHardBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [],animations: {
            if self.mFirstShow! {
                self.mRecordsBtn.center.x  += self.view.bounds.width
            }
            else{
                self.mRecordsBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.25, options: [],animations: {
            if self.mFirstShow! {
                self.mInstructionBtn.center.x  += self.view.bounds.width
            } else{
                self.mInstructionBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        
        self.mFirstShow = false
        
        guard Reachability.isLocationEnable() == true else  {
            AlertsHandler.showAlertMessage(title: "Location needed", message: "Please allow location to play", cancelButtonTitle: "OK")
            self.mInstructionBtn.isEnabled = true
            return
        }
        
        guard Reachability.isConnectedToNetwork() == true else {
            print("Internet Connection not Available!")
            self.mIsNetworkEnabled = false
            self.mRecordsBtn.isEnabled = false
            return
        }
        
        checkGPS()
        enableAllBtns()
        self.mIsNetworkEnabled = true
        
    }

    func enableAllBtns() {
        self.mEazyBtn.isEnabled = true
        self.mNormalBtn.isEnabled = true
        self.mHardBtn.isEnabled = true
        self.mRecordsBtn.isEnabled = true
        self.mInstructionBtn.isEnabled = true
    }
    
    func unableAllBtns() {
        self.mEazyBtn.isEnabled = false
        self.mNormalBtn.isEnabled = false
        self.mHardBtn.isEnabled = false
        self.mRecordsBtn.isEnabled = false
        self.mInstructionBtn.isEnabled = false
    }
    
    // MARK: Actions
    @IBAction func eazyLevelBtn(_ sender: UIButton) {
        unableAllBtns()
        sender.touch()
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.mGameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        
        guard self.mGameViewController != nil else {
            return
        }
        
        self.mGameViewController!.mDiff = 0
        self.mGameViewController!.mIsNetworkEnabled = self.mIsNetworkEnabled
        self.mGameViewController!.mCurrentLat = self.mCurrentLat
        self.mGameViewController!.mCurrentLong = self.mCurrentLong
        
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.navigationController?.pushViewController(self.mGameViewController!, animated: true)
        })
    }
    
    @IBAction func normalLevelBtn(_ sender: UIButton) {
        unableAllBtns()
        sender.touch()
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.mGameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        
        guard self.mGameViewController != nil else {
            return
        }
        
        self.mGameViewController!.mDiff = 1
        self.mGameViewController!.mIsNetworkEnabled = self.mIsNetworkEnabled
        self.mGameViewController!.mCurrentLat = self.mCurrentLat
        self.mGameViewController!.mCurrentLong = self.mCurrentLong
        
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.navigationController?.pushViewController(self.mGameViewController!, animated: true)
        })
    }
    
    @IBAction func hardLevelBtn(_ sender: UIButton) {
        unableAllBtns()
        sender.touch()
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.mGameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        
        guard self.mGameViewController != nil else {
            return
        }
        
        self.mGameViewController!.mDiff = 2
        self.mGameViewController!.mIsNetworkEnabled = self.mIsNetworkEnabled
        self.mGameViewController!.mCurrentLat = self.mCurrentLat
        self.mGameViewController!.mCurrentLong = self.mCurrentLong
        
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.navigationController?.pushViewController(self.mGameViewController!, animated: true)
        })
    }
    
    @IBAction func recordsBtn(_ sender: UIButton) {
        unableAllBtns()
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
        unableAllBtns()
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
    
    func checkGPS() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = self.mLocationManager.location else {
                return
            }
            self.mCurrentLat = currentLocation.coordinate.latitude
            self.mCurrentLong = currentLocation.coordinate.longitude
        }
    }
}


// extension for map view
extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            self.mEazyBtn.isEnabled = false
            self.mNormalBtn.isEnabled = false
            self.mHardBtn.isEnabled = false
            self.mRecordsBtn.isEnabled = false
            self.mInstructionBtn.isEnabled = true
            return
        }
        self.mLocationManager.startUpdatingLocation()
        enableAllBtns()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.mLocationManager.stopUpdatingLocation()
    }
}
