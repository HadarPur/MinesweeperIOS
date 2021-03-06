//
//  scoreViewController.swift
//  Minesweeper
//
//  Created by Hadar Pur on 22/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ScoreViewController: UIViewController, UITextFieldDelegate {
    // outlet
    @IBOutlet weak var mCancelBtn: UIButton!
    @IBOutlet weak var mSaveBtn: UIButton!
    @IBOutlet weak var mTextField: UITextField!
    
    let WIN: Int = 1
    let MAX_RECORDS: Int = 10
    let mFunctions = FuncUtils()
    let mFbStorage = FirebaseStorage()

    var mLatitude: Double?
    var mLongitude: Double?
    var mIndex: Int?
    var mPoints: Int?
    var mLevel: Int?
    var mName: String?
    
    var mUsersData : Array<UserInfo>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableAllBtns()
    }
    
    //hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func SaveBtn(_ sender: UIButton) {
        unableAllBtns()
        sender.touch()
        
        guard let name = self.mTextField.text, !name.isEmpty else {
            enableAllBtns()
            mFunctions.showToast(msg: "Please enter your name to save")
            return
        }
        
        self.mName = name
        self.mIndex = self.mUsersData!.count
        
        let userInfo: UserInfo =  UserInfo()
        userInfo.UserInfo(key: self.mIndex!, name: self.mName!, latitude: self.mLatitude ?? 0, longitude: self.mLongitude ?? 0, points: self.mPoints!, level: self.mLevel ?? 0)
        
        if self.mIndex! >= MAX_RECORDS {
            print("level: \(self.mLevel!)")
            self.mFbStorage.replaceUser(user: userInfo, level: self.mLevel!, users: self.mUsersData!)
        }
        else {
            self.mFbStorage.writeUser(user: userInfo, level: self.mLevel!)
            print("level: \(self.mLevel!)")
        }
        moveToResultsViewController()
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        unableAllBtns()
        sender.touch()
        
        moveToResultsViewController()
    }
    
    func moveToResultsViewController() {
        let deadlineTime = DispatchTime.now() + .milliseconds(1000)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let resultsViewController = storyBoard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController
        
        guard resultsViewController != nil else {
            return
        }
        
        resultsViewController!.mStatus = false
        resultsViewController!.mState = true
        resultsViewController!.mLevel = self.mLevel
        resultsViewController!.mPoints = self.mPoints ?? 0
        resultsViewController!.mIsNetworkEnabled = true
        
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.navigationController?.pushViewController(resultsViewController!, animated: true)
        })
    }
    
    func unableAllBtns() {
        self.mCancelBtn.isEnabled = false
        self.mSaveBtn.isEnabled = false
    }
    
    func enableAllBtns() {
        self.mCancelBtn.isEnabled = true
        self.mSaveBtn.isEnabled = true
    }
    
}
