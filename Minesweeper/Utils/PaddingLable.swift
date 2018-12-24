//
//  PaddingLable.swift
//  Minesweeper
//
//  Created by Hadar Pur on 28/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import Foundation
import UIKit

class PaddingLabel: UILabel {
    let mPadding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.mPadding))
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + self.mPadding.left + self.mPadding.right
        let height = superSizeThatFits.height + self.mPadding.top + self.mPadding.bottom
        return CGSize(width: width, height: height)
    }
}
