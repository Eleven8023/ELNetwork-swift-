//
//  Dictionart+Extension.swift
//  DoctorSwift
//
//  Created by Eleven on 16/12/8.
//  Copyright © 2016年 Eleven. All rights reserved.
//

import Foundation

extension Dictionary {
    func transformedForArray(sign:Bool) -> Array<String> {
        var array = [String]()
        
        for (key, value) in self {
            var valueString = "\(value)"
            
            if sign == false{
                valueString = CFURLCreateStringByAddingPercentEscapes(nil, valueString as CFString!, nil, "!*'();:@&=+$,/?%#[]" as CFString!, CFStringBuiltInEncodings.UTF8.rawValue) as String
            }
            
            array.append("\(key)=\(valueString)")
        }
        array = array.sorted()
        return array
    }
    
    func transformedForString(sign:Bool) -> String {
        let array = transformedForArray(sign: sign)
        return array.convertToString()
    }
    
    func jsonString() -> String {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self), let stringForJson = String.init(data: jsonData, encoding: .utf8) else {
            return ""
        }
        return stringForJson

    }
    
    
}

