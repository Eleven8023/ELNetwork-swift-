
//
//  NetworkConfig.swift
//  ELSwiftNetwork
//
//  Created by Eleven on 17/1/6.
//  Copyright © 2017年 Eleven. All rights reserved.
//

import Foundation

typealias ALCallBack = (ALURLResponse) ->()

enum ALURLResponseStatus {
    case success // 成功接收反馈
    case timeOut // 网络连接超时
    case onConnect  // 未连接服务器
    case noNetwork  // 无网络错误
    case cancel     // 取消
}

enum ALAPIDataStatus: Int{
    case success = 200
}

let KSFNetworkAppKey = "483OedYnY945yTfdUd5Rxruf"

let KSFNetworkAppSecret = "1rogPFfwMpa3U5cgrjsns99wy2QSx909"

let BASEURL = "https://api.witspring.com"//http://service.witspring.net:81  https://api.witspring.com/

let cerName = "severProduction.cer"//severProduction.cer
