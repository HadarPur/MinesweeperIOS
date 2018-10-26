//
//  ViewController.swift
//  Minesweeper
//
//  Created by Hadar Pur on 04/09/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var firstAsk = true
    var mGameViewController: GameViewController?
    var firstShow: Bool = true
    @IBOutlet weak var mEazyBtn: UIButton!
    @IBOutlet weak var mNormalBtn: UIButton!
    @IBOutlet weak var mHardBtn: UIButton!
    @IBOutlet weak var mRecordsBtn: UIButton!
    @IBOutlet weak var mInstructionBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        if (firstShow) {
            mEazyBtn.center.x  -= view.bounds.width
            mNormalBtn.center.x  -= view.bounds.width
            mHardBtn.center.x  -= view.bounds.width
            mRecordsBtn.center.x  -= view.bounds.width
            mInstructionBtn.center.x  -= view.bounds.width
        }
        else {
            mEazyBtn.center.x  += view.bounds.width
            mNormalBtn.center.x  += view.bounds.width
            mHardBtn.center.x  += view.bounds.width
            mRecordsBtn.center.x  += view.bounds.width
            mInstructionBtn.center.x  += view.bounds.width
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0.05, options: [], animations: {
            if (self.firstShow) {
                self.mEazyBtn.center.x  += self.view.bounds.width
            }
            else{
                self.mEazyBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: {
            if (self.firstShow) {
                self.mNormalBtn.center.x  += self.view.bounds.width
            }
            else{
                self.mNormalBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.15, options: [], animations: {
           if (self.firstShow) {
                self.mHardBtn.center.x  += self.view.bounds.width
           }
            else{
                self.mHardBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [],animations: {
            if (self.firstShow) {
                self.mRecordsBtn.center.x  += self.view.bounds.width
            }
            else{
                self.mRecordsBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.25, options: [],animations: {
            if (self.firstShow) {
                self.mInstructionBtn.center.x  += self.view.bounds.width
            }
            else{
                self.mInstructionBtn.center.x  -= self.view.bounds.width
            }
        }, completion: nil)
        
        firstShow = false
    }

    @IBAction func eazyLevelBtn(_ sender: UIButton) {
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
        sender.touch()
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.mGameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        
        guard self.mGameViewController != nil else {
            return
        }
        
        self.mGameViewController!.mDiff = 1
//        self.mGameViewController!.mGameBoard.size
//        self.mGameViewController!.mGameBoard.numberOfItems(inSection: 10)

        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.navigationController?.pushViewController(self.mGameViewController!, animated: true)
        })
    }
    
    @IBAction func hardLevelBtn(_ sender: UIButton) {
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

