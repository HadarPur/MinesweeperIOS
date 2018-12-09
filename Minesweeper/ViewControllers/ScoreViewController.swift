//
//  scoreViewController.swift
//  Minesweeper
//
//  Created by Hadar Pur on 22/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import Foundation
import UIKit

class ScoreViewController: UIViewController {
    @IBOutlet weak var mCancelBtn: UIButton!
    @IBOutlet weak var mSaveBtn: UIButton!
    @IBOutlet weak var mTextField: UITextField!
    
    let WIN: Int = 1, MAX_RECORDS: Int = 10
    var mLatitude: Double?, mLongitude: Double?
    var mPoints: Int?, mLevel: Int?, mIndex: Int?
    var mName: String?
    var mUsersData : Array<UserInfo> = Array()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func getResults() {
        
    }
    @IBAction func SaveBtn(_ sender: Any) {
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        moveToResultsViewController()
    }
    
    func moveToResultsViewController() {
        let deadlineTime = DispatchTime.now() + .milliseconds(1000)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let resultsViewController = storyBoard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController
        
        guard resultsViewController != nil else {
            return
        }
        
        resultsViewController?.mStatus = false
        resultsViewController?.mState = true

        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.navigationController?.pushViewController(resultsViewController!, animated: true)
        })
    }
}
