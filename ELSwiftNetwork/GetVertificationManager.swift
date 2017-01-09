//
//  GetVertificationManager.swift
//  ELSwiftNetwork
//
//  Created by Eleven on 17/1/9.
//  Copyright © 2017年 Eleven. All rights reserved.
//

import UIKit

class GetVertificationManager: ALNetBaseManager, ALNetManagerProtocol, ALNetManagerCallBackDelegate, ALNetManagerCallBackDataSource {
    internal func callApiDidFailed(manager: ALNetBaseManager) {
        
    }
    
    internal func callApiDidSuccess(manager: ALNetBaseManager) {
        
    }
    
    internal func paramsForRequest(manager: ALNetBaseManager) -> [String : Any] {
        var params:[String:Any] = NSDictionary() as! [String : Any]
        params["user_id"] = userId
        params["mobile"] = mobile
        params["type"] = "6"
        return params
    }
    
    var methodName: String = "GET-VERIFICATION-CODE"
    var servicePath: String = "/service/user/sms/getVerificationCode.do"
    var userId:String!
    var mobile:String!
    var requestType: ALNetManagerRequestType = .post
    
    override init() {
        super.init()
        self.delegate = self
        self.dataSource = self
    }
    
    internal func cleanData() {
        
    }

}
