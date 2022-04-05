//
//  CustomClasses.swift
//  ColorWheel
//
//  Created by Jayesh Tejwani on 05/04/22.
//

import UIKit

class KPRoundButton: UIButton {
    
    @IBInspectable var isRatioAppliedOnSize: Bool = false
    
    @IBInspectable var cornerRadious: CGFloat = 0{
        didSet{
            if cornerRadious == 0{
                layer.cornerRadius = (self.frame.height * _widthRatio) / 2
            }else{
                layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
}
