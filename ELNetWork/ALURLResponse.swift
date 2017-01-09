//
//  ALURLResponse.swift
//  ELSwiftNetwork
//
//  Created by Eleven on 17/1/9.
//  Copyright © 2017年 Eleven. All rights reserved.
//

import Foundation

struct ALURLResponse {
    var status: ALURLResponseStatus
    var content: Dictionary<String, Any>?
    var request: URLRequest?
    var isCache: Bool
    
    init(error:Error?, content: Dictionary<String, Any>?,request:URLRequest?,isCache:Bool = false) {
        if let error = error{
            let errorDes = error.localizedDescription
            
            if errorDes.contains("已取消") {
                self.status = .cancel
            }else if errorDes.contains("请求超时"){
                self.status = .timeOut
            }else if errorDes.contains("未能连接到服务器"){
                self.status = .onConnect
            }else{
                self.status = .noNetwork
            }
        }else{
            self.status = .success
        }
        
        self.content = content
        self.request = request!
        self.isCache = isCache        
    }
    
}

















