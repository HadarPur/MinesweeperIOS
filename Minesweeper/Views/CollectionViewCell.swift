//
//  CollectionViewCell.swift
//  Minesweeper
//
//  Created by Hadar Pur on 27/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLable: UILabel!

    func displayContent(image: UIImage, text: String) {
        cellImage.image = image
        cellLable.text = text
    }
}
