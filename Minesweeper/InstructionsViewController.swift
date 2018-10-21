//
//  InstructionsViewController.swift
//  Minesweeper
//
//  Created by Hadar Pur on 21/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import UIKit
class InstructionsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)

    }
}
