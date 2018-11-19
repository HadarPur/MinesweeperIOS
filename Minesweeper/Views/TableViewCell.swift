//
//  TableViewCell.swift
//  Minesweeper
//
//  Created by Hadar Pur on 19/11/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    var title: String!
    @IBOutlet weak var textLable: UILabel!
    
    func configure(title: String) {
        self.title = title
    }
}

