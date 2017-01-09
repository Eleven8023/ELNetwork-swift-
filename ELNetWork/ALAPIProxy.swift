//
//  ALAPIProxy.swift
//  ELSwiftNetwork
//
//  Created by Eleven on 17/1/6.
//  Copyright © 2017年 Eleven. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ALAPIProxy: NSObject {
    // MARK: - Singleton
    static let shareInstance = ALAPIProxy.init()
    private var session = SessionManager.default
    
    private override init() {
        super.init()
    }
    
    private func configRequestParams(params:inout [String:Any]){
        // 签名业务参数
        var paramsArray = params.transformedForArray(sign: true)
        paramsArray.append("app_secret=\(KSFNetworkAppSecret)")
        // 生成签名, 请求参数拼接签名
        params["sign"] = paramsArray.convertToString().md5
    }
    
    private func configRequestSecurity() -> SessionManager{
        let path = Bundle.main.path(forResource: cerName, ofType: nil)
        let cerData = NSData.init(contentsOfFile: path!)
        let citificate = SecCertificateCreateWithData(nil, cerData!)
        let serverTrustPolicy = ServerTrustPolicy.pinCertificates(certificates: [citificate!], validateCertificateChain: true, validateHost: false)
        let serverTrustPolicies:[String:ServerTrustPolicy] = ["api.witspring.com":serverTrustPolicy]
        
        let serverTrustPolicyManager = ServerTrustPolicyManager(policies:serverTrustPolicies)
        
        let sessionManager = SessionManager(
            serverTrustPolicyManager:serverTrustPolicyManager
        )
        return sessionManager;
    }
    
    func callGetTypeRequest(urlStr:String, params:[String:Any], callback:@escaping ALCallBack) -> Request {
        var paramsSigned = params
        configRequestParams(params: &paramsSigned)
        
        if BASEURL.hasPrefix("https") {
            session = configRequestSecurity()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return session.request(urlStr, method: .get, parameters: paramsSigned).responseJSON(completionHandler: { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            switch response.result {
            case let .success(value):
                let urlResponse = ALURLResponse.init(error: nil, content: value as? Dictionary<String, Any>, request: response.request)
                callback(urlResponse)
            case let .failure(error):
                let urlResponse = ALURLResponse.init(error: error, content: nil, request: response.request)
                callback(urlResponse)
            }
        print(response)
        })
    }
    
    func callPostTypeRequest(urlStr:String, params:[String:Any], callback:@escaping ALCallBack) -> Request {
        var paramsSigned = params
        configRequestParams(params: &paramsSigned)
        
        if BASEURL.hasPrefix("https") {
            session = configRequestSecurity()
        }
        
        print("\(urlStr) \nparams:\n\(paramsSigned)")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return session.request(urlStr, method: .post, parameters: paramsSigned).responseJSON(completionHandler: { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            switch response.result {
            case let .success(value):
                let urlResponse = ALURLResponse.init(error: nil, content: value as? Dictionary<String, Any>, request: response.request)
                callback(urlResponse)
            case let .failure(error):
                let urlResponse = ALURLResponse.init(error: error, content: nil, request: response.request)
                callback(urlResponse)
            }
            print(response)
        })
    }
    
}






















