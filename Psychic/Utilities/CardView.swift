//
//  CardView.swift
//  NCT
//
//  Created by Shahbaz on 12/26/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {

    
    @IBInspectable var corRad : CGFloat = 30
    @IBInspectable var shadowWidth : CGFloat = 0
    @IBInspectable var shadowHeight : CGFloat = 5
    @IBInspectable var shadColor  : UIColor = UIColor.black
    @IBInspectable var opacity : CGFloat  = 0.5
    
    
    
    override func layoutSubviews() {
        
        layer.cornerRadius = corRad
        layer.shadowColor = shadColor.cgColor
        layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
        
        
        let shadowPath  = UIBezierPath(roundedRect: bounds, cornerRadius: corRad)
        
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(opacity)
        
        
        
        
        
        
    }
    
    
    
    

}
