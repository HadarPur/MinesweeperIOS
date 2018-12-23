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

    var mOriginalX: CGFloat?
    var mOriginalY: CGFloat?

    var mRow: Int!
    var mCol: Int!
    var mStatus: Int!
    var mIsPressed: Bool!
    var mIsLongPressed: Bool!

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(row: Int, col: Int, status: Int) {
        self.mRow = row
        self.mCol = col
        self.mStatus = status
        self.mIsPressed = false
        self.mIsLongPressed = false
    }
    
    // returns number of bombs around the cell
    func getStatus() -> Int {
        return self.mStatus
    }
    
    //set number of bombs around the cell
    func setStatus(status: Int){
        self.mStatus = status
    }
    
    // chang cell status to be pressed
    func pressButton() {
        self.mIsPressed = true
    }
    
    //update cell status to be unpressed
    func unPress() {
        self.mIsPressed = false
    }
    
    //returns if cell was pressed
    func pressed() -> Bool{
        return self.mIsPressed
    }
    
    //returns if cell was long pressed
    func pressLongButton() {
        if self.mIsLongPressed == true {
            self.mIsLongPressed = false
        }
        else {
            self.mIsLongPressed = true
        }
    }
    
    // chang cell status to be long pressed
    func longPressed() -> Bool{
        return self.mIsLongPressed
    }
}
