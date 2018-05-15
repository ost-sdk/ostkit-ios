//
//  ViewController.swift
//  iOS Example
//
//  Created by Duong Khong on 5/15/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import UIKit
import ostkit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let sdk = OSTSDK(baseURLString: BASE_URL_STRING, key: API_KEY, serect: API_SECRET, debugMode: true)
        let userService = sdk.userServices()
        userService.list(filter: .all, orderBy: .creationTime, order: .desc) {
            response in
            debugPrint(response)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

