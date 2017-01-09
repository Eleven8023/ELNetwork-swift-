//
//  LoginNetManager.swift
//  ELSwiftNetwork
//
//  Created by Eleven on 17/1/9.
//  Copyright © 2017年 Eleven. All rights reserved.
//

import UIKit

class LoginNetManager: ALNetBaseManager, ALNetManagerProtocol, ALNetManagerCallBackDelegate, ALNetManagerCallBackDataSource {
    internal func callApiDidFailed(manager: ALNetBaseManager) {
        
    }
    internal func callApiDidSuccess(manager: ALNetBaseManager) {
        
    }
    internal func paramsForRequest(manager: ALNetBaseManager) -> [String : Any] {
        var params:[String:Any] = NSDictionary() as! [String:Any]
        params["mobile"] = phoneNumber
        params["verification_code"] = vertificationCode
        params["type"] = "6"
        return params
    }
    
    var methodName: String = "QUICK-LOGIN"
    var servicePath: String = "/service/user/quickLogin.do"
    var phoneNumber:String!
    var vertificationCode:String!
    var requestType: ALNetManagerRequestType = .post
    
    override init() {
        super.init()
        self.delegate = self
        self.dataSource = self
    }
    
    internal func cleanData() {
    }

}


























