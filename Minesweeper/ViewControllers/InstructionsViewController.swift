//
//  InstructionsViewController.swift
//  Minesweeper
//
//  Created by Hadar Pur on 21/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import UIKit
class InstructionsViewController: UIViewController {
    
    @IBOutlet weak var textViewField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewField.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)

    }
    
    
}
