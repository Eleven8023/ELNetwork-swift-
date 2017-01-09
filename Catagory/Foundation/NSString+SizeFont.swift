//
//  NSString+SizeFont.swift
//  DoctorSwift
//
//  Created by Eleven on 16/12/7.
//  Copyright © 2016年 Eleven. All rights reserved.
//

import Foundation
import UIKit


extension NSString {
    class func autoLabelSize(font:UIFont,drawSize:CGSize) -> CGSize{
        var size = CGSize()
        size = String(describing: self).boundingRect(with:drawSize,options:NSStringDrawingOptions.usesLineFragmentOrigin,attributes:[NSFontAttributeName:font],context:nil).size
        return size
    }
    
    class func calculateOfContent(fWidth:CGFloat,fontSize:CGFloat,lineSpacing:CGFloat) -> CGSize{
        var size = CGSize()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attribute = [NSFontAttributeName:[UIFont .boldSystemFont(ofSize: fontSize)],NSParagraphStyleAttributeName:paragraphStyle] as [String : Any]
        size = String(describing: self).boundingRect(with:CGSize(width:fWidth,height:CGFloat.greatestFiniteMagnitude),options:NSStringDrawingOptions.usesLineFragmentOrigin,attributes:attribute, context:nil).size
        return size
    }
}



