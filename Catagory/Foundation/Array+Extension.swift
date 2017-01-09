//
//  Array+Extension.swift
//  DoctorSwift
//
//  Created by Eleven on 16/12/8.
//  Copyright © 2016年 Eleven. All rights reserved.
//

import Foundation

extension Array where Element: Comparable{
    func convertToString() -> String {
        var stringForArray = ""
        let sortedArray = self.sorted(by:{ $0 < $1 })
        for (index,value) in sortedArray.enumerated() {
            if index == 0{
                stringForArray = ("\(value)")
            }else{
                stringForArray += ("&\(value)")
            }
        }
        return stringForArray
    }
    
    func jsonString() -> String {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self), let stringForJson = String.init(data: jsonData, encoding: .utf8) else {
            return ""
        }
        
        return stringForJson
    }
    
}



