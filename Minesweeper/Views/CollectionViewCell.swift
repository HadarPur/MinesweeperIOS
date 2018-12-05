//
//  CollectionViewCell.swift
//  Minesweeper
//
//  Created by Hadar Pur on 27/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLable: UILabel!
    
    
    var row: Int!
    var col: Int!
    var status: Int!
    var isPressed: Bool!
    var isLongPressed: Bool!
    let unPressedImage = UIImage(named: "table.png") as UIImage?

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configure(row: Int, col: Int, status: Int) {
        self.row = row
        self.col = col
        self.status = status
        self.isPressed = false
        self.isLongPressed = false

    }
    
    // returns number of bombs around the cell
    func getStatus() -> Int {
        return self.status
    }
    
    //set number of bombs around the cell
    func setStatus(status: Int){
        self.status = status
    }
    
    // chang cell status to be pressed
    func pressButton() {
        self.isPressed = true
    }
    
    //update cell status to be unpressed
    func unPress() {
        self.isPressed = false
    }
    
    //returns if cell was pressed
    func pressed() -> Bool{
        return self.isPressed
    }
    
    //returns if cell was long pressed
    func pressLongButton() {
        if self.isLongPressed == true {
            self.isLongPressed = false
        }
        else {
            self.isLongPressed = true
        }
    }
    
    // chang cell status to be long pressed
    func longPressed() -> Bool{
        return self.isLongPressed
    }
    
}
