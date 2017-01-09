//
//  ViewController.swift
//  ELSwiftNetwork
//
//  Created by Eleven on 17/1/6.
//  Copyright © 2017年 Eleven. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ALNetManagerInterceptor {

    func beforeCallApi(manager: ALNetBaseManager) {
        print("在请求之前,加载菊花")
    }
    func afterRequestResponse(manager: ALNetBaseManager) {
        print("在请求之后, 隐藏菊花")
        if manager == getVertificationManager {
            print("result is \(manager.fetchedRawData)")
        }
    }
    
    lazy var getVertificationManager = {
        return GetVertificationManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVertificationManager.interceptor = self
        getVertificationManager.mobile = "13935667890"
        getVertificationManager.userId = ""
        _ = getVertificationManager.loadData()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

