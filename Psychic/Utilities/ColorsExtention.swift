//
//  ColorsExtention.swift
//  Psychic
//
//  Created by APPLE on 1/14/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
