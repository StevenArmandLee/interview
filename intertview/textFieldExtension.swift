//
//  textFieldExtension.swift
//  intertview
//
//  Created by steven lee on 15/8/16.
//  Copyright © 2016 steven lee. All rights reserved.
//

import UIKit
extension UITextField {
    func removeBorder() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.orangeColor().CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.borderStyle = .None
        let placeHolder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        self.attributedPlaceholder = placeHolder
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true

    }
}