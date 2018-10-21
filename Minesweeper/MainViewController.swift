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

    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func eazyLevelBtn(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.mGameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        
        guard self.mGameViewController != nil else {
            return
        }
        
        self.mGameViewController!.mDiff = 0
        self.navigationController?.pushViewController(self.mGameViewController!, animated: true)
    }
    
    @IBAction func normalLevelBtn(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.mGameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        
        guard self.mGameViewController != nil else {
            return
        }
        
        self.mGameViewController!.mDiff = 1
        self.navigationController?.pushViewController(self.mGameViewController!, animated: true)
    }
    
    @IBAction func hardLevelBtn(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.mGameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        
        guard self.mGameViewController != nil else {
            return
        }
        
        self.mGameViewController!.mDiff = 2
        self.navigationController?.pushViewController(self.mGameViewController!, animated: true)
    }
    
    @IBAction func recordsBtn(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let recordsViewController = storyBoard.instantiateViewController(withIdentifier: "RecordsViewController") as? RecordsViewController
        
        guard recordsViewController != nil else {
            return
        }
        
        self.navigationController?.pushViewController(recordsViewController!, animated: true)
    }
    
    @IBAction func instructionsBtn(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let instrucionsViewController = storyBoard.instantiateViewController(withIdentifier: "InstructionsViewController") as? InstructionsViewController
        
        guard instrucionsViewController != nil else {
            return
        }
        
        self.navigationController?.pushViewController(instrucionsViewController!, animated: true)
    }
}

