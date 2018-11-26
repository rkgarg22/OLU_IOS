//
//  ProgressBarCustomClass.swift
//  Sona Circle
//
//  Created by Apple on 23/08/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

@IBDesignable class ProgressViewCustom: UIProgressView
{
    override func awakeFromNib() {
        super.awakeFromNib()
    self.transform = CGAffineTransform(scaleX: 1.0, y: 10.0)
    }
}
