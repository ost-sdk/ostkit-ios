//
//  ViewController.swift
//  iOS Example
//
//  Created by Duong Khong on 5/15/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import UIKit
import ostkit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let sdk = OSTSDK(baseURLString: BASE_URL_STRING, key: API_KEY, serect: API_SECRET)
        let userService = sdk.userServices()
        userService.create(name: "duong") {
            response in
            debugPrint(response)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

