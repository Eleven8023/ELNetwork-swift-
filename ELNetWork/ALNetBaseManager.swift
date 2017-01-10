//
//  ALNetBaseManager.swift
//  ELSwiftNetwork
//
//  Created by Eleven on 17/1/9.
//  Copyright © 2017年 Eleven. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
// MARK:- errorType
enum ALNetManagerErrorType {
    case noRequest
    case success
    case noConnect
    case paramsError
    case timeout
    case noNetWork
}
// MARK:- requestType
enum ALNetManagerRequestType {
    case get
    case post
}
// MARK: - protocol 调用业务接口成功与失败
protocol ALNetManagerCallBackDelegate:NSObjectProtocol {
    func callApiDidSuccess(manager:ALNetBaseManager)
    func callApiDidFailed(manager:ALNetBaseManager)
    
}
// MARK: - protocol 成功后返回数据
protocol ALNetManagerCallBackDataSource:NSObjectProtocol {
    func paramsForRequest(manager:ALNetBaseManager) -> [String:Any]
}
// MARK: - interceptor 调用前和成功后操作
protocol ALNetManagerInterceptor:NSObjectProtocol {
    func beforeCallApi(manager:ALNetBaseManager)
    func afterRequestResponse(manager:ALNetBaseManager)
}

protocol ALNetManagerCallbackDataReformer:NSObjectProtocol {
    func reformerData(manager:ALNetBaseManager, data:Any) -> Any
}
// MARK: - 属性名称 methodName 接口名称  servicePath: 接口路径 requestType: 请求类型 方法:cleanData
protocol ALNetManagerProtocol:NSObjectProtocol {
    var methodName: String{ get set }
    var servicePath: String{ get set }
    var requestType: ALNetManagerRequestType { get set }
    
    func cleanData()
}

class ALNetBaseManager: NSObject {
    weak var delegate: ALNetManagerCallBackDelegate?
    weak var dataSource: ALNetManagerCallBackDataSource?
    weak var interceptor: ALNetManagerInterceptor?
    weak var child: ALNetManagerProtocol?
    
    private(set) var errorType: ALNetManagerErrorType
    private var requestIdList: [Request]?
    var status: (code: Int, msg: String)?
    var fetchedRawData: Any?
    
    private var isLoading: Bool {
        get{
            if let requestIdList = requestIdList {
                return requestIdList.count > 0
            }
            return false
        }
    }
    var isReachable: Bool{
        get{
            if let network = NetworkReachabilityManager.init() {
                return network.isReachable
            }
            return false
        }
    }
    
    override init() {
        errorType = .noRequest
        requestIdList = []
        super.init()
        
        if ((self as? ALNetManagerProtocol) != nil) {
            self.child = (self as? ALNetManagerProtocol)
        }
    }
    
    deinit {
        cancellAllRequests()
        requestIdList = nil
        fetchedRawData = nil
    }
    
    func cancellAllRequests(){
        if let requestIdList = requestIdList {
            for request in requestIdList {
                request.cancel()
            }
        }
    }
    
    func fetchData(reformer:ALNetManagerCallbackDataReformer) -> Any? {
        var reformerResualt: Any?
        if let fetchedRawData = fetchedRawData {
            reformerResualt = reformer.reformerData(manager: self, data: fetchedRawData)
        }
        return reformerResualt
    }
    
    func loadData() -> Request? {
        if let dataSource = dataSource {
            var params = dataSource.paramsForRequest(manager: self)
        // MARK: 公参配置 这里是action是根据事例后台配置每个接口对应的名称 具体配置根据自己业务而定
            params["action"] = child?.methodName
            params["version"] = "2.1.2"
            params["app_key"] = KSFNetworkAppKey
            params["uuid"] = "B6AA01FB-7556-4018-85FA-6A072BC1BDEC"
            params["platform"] = "1"
            params["timestap"] = "1481014736"
            
            return loadData(params:params)
        }
        return nil
    }
    // MARK: Request
    func loadData(params:[String:Any]) -> Request? {
        guard let childManager = child else {
            return nil
        }
        
        var request:Request?
        
        let callback: ALCallBack = {[weak self] responseInfo in
            switch responseInfo.status {
            case .cancel:
                break
            case .success:
                self?.successOnCallingAPI(responseInfo: responseInfo)
            case .onConnect:
                self?.failedOnCallingAPI(responseInfo: responseInfo, errorType: .noConnect)
            case .noNetwork:
                self?.failedOnCallingAPI(responseInfo: responseInfo, errorType: .noNetWork)
            case .timeOut:
                self?.failedOnCallingAPI(responseInfo: responseInfo, errorType: .timeout)
            }
        }
        
        if isReachable {
            beforeCallingAPI()
            
            let urlStr = BASEURL + childManager.servicePath
            
            switch childManager.requestType {
            case .post:
                request = ALAPIProxy.shareInstance.callPostTypeRequest(urlStr: urlStr, params: params, callback: callback)
                print("post")
            case .get:
                request = ALAPIProxy.shareInstance.callGetTypeRequest(urlStr: urlStr, params: params, callback: callback)
                print("get")
            }
            if request != nil {
                requestIdList?.append(request!)
            }
        }else{
            failedOnCallingAPI(responseInfo: ALURLResponse.init(error: nil, content: nil, request: nil), errorType: .noNetWork)
        }
        
        return request
    }
    
    // MARK: - api callback  status  状态吗 msg 请求信息  data 数据源 根据业务而定
    
    func successOnCallingAPI(responseInfo:ALURLResponse) {
        if let request = responseInfo.request {
            removeRequestFromList(request: request)
        }
        
        if let contentDic = responseInfo.content{
            if let codeValue = contentDic["status"], let code = (codeValue as? Int), let msgValue = contentDic["msg"], let msg = (msgValue as? String){
                status = (code, msg)
            } else {
                status = (ALAPIDataStatus.success.rawValue,"成功返回")
            }
            
            fetchedRawData = contentDic["data"]
            
            delegate?.callApiDidSuccess(manager: self)
            afterReciverAPIResponse()
        }else{
            failedOnCallingAPI(responseInfo: responseInfo, errorType: .noNetWork)
        }
        
    }
    
    func failedOnCallingAPI(responseInfo:ALURLResponse, errorType:ALNetManagerErrorType){
        self.errorType = errorType
        status = nil
        fetchedRawData = nil
        if let request = responseInfo.request {
            removeRequestFromList(request: request)
        }
        
        delegate?.callApiDidFailed(manager: self)
        afterReciverAPIResponse()
        
    }
    
    private func beforeCallingAPI() {
        interceptor?.beforeCallApi(manager: self)
    }
    
    private func  afterReciverAPIResponse() {
        interceptor?.afterRequestResponse(manager: self)
    }
    
    private func removeRequestFromList(request: URLRequest) {
        guard requestIdList != nil else {
            return
        }
        
        for (index, value) in requestIdList!.enumerated() {
            if value.request == request {
                value.cancel()
                requestIdList!.remove(at: index)
            }
        }
    }
}

















