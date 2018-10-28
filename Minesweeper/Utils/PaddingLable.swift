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
        super.drawText(in: UIEdgeInsetsInsetRect(rect, mPadding))
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + mPadding.left + mPadding.right
        let height = superSizeThatFits.height + mPadding.top + mPadding.bottom
        return CGSize(width: width, height: height)
    }
}
