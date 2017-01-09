//
//  UIButton+Extension.swift
//  DoctorSwift
//
//  Created by Eleven on 16/12/12.
//  Copyright © 2016年 Eleven. All rights reserved.
//

import Foundation
import UIKit




enum ELButtonStyle {
    case ELButtonEdgeInsetsStyleTop // image在上 label在下
    case ELButtonEdgeInsetsStyleLeft // image在左 lable在右
    case ELButtonEdgeInsetsStyleBottom  // image在下 label在上
    case ELButtonInsetsStyleRight  // image在右, label在左
}


extension UIButton {
    func layoutButtonWithEdgeInsetsStyle(style:ELButtonStyle,imageTitleSpace:CGFloat) {
        let imageWidth:CGFloat = (self.imageView?.frame.size.width)!
        let imageHeight:CGFloat = (self.imageView?.frame.size.height)!
        var labelWidth:CGFloat = 0.0
        var labelHeight:CGFloat = 0.0
        
        if (UIDevice.current.systemVersion as NSString).floatValue >= 8.0{
            labelWidth = (self.titleLabel?.intrinsicContentSize.width)!
            labelHeight = (self.titleLabel?.intrinsicContentSize.height)!
        } else {
            labelWidth = (self.titleLabel?.frame.size.width)!
            labelHeight = (self.titleLabel?.frame.size.height)!
        }
        
        var imageEdgeInsets:UIEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets:UIEdgeInsets = UIEdgeInsets.zero
        
        switch style {
        case .ELButtonEdgeInsetsStyleTop:
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-imageTitleSpace/2.0, 0, 0, -labelWidth)
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, -imageHeight-imageTitleSpace/2.0, 0)
        case .ELButtonEdgeInsetsStyleLeft:
            imageEdgeInsets = UIEdgeInsetsMake(0, -imageTitleSpace/2.0, 0, imageTitleSpace/2.0)
            labelEdgeInsets = UIEdgeInsetsMake(0, imageTitleSpace/2.0, 0, -imageTitleSpace/2.0)
        case .ELButtonEdgeInsetsStyleBottom:
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-imageTitleSpace, -labelWidth)
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-imageTitleSpace/2.0, -imageWidth, 0, 0)
        case .ELButtonInsetsStyleRight:
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+imageTitleSpace/2.0, 0, -labelWidth-imageTitleSpace/2.0)
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth-imageTitleSpace/2.0, 0, imageWidth+imageTitleSpace/2.0)
        }
        self.imageEdgeInsets = imageEdgeInsets
        self.titleEdgeInsets = labelEdgeInsets
    }
}
