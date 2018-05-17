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

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private var pageVC: UIPageViewController!
    private var transactionVC: TransactionViewController!
    private var userVC: UserViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        transactionVC = storyboard!.instantiateViewController(withIdentifier: "TransVC") as! TransactionViewController
        userVC = storyboard!.instantiateViewController(withIdentifier: "UserVC") as! UserViewController
        
        pageVC = segue.destination as! UIPageViewController
        pageVC.delegate = self
        pageVC.dataSource = self
        pageVC.setViewControllers([transactionVC], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pageVC.setViewControllers([transactionVC], direction: .forward, animated: true, completion: nil)
        } else {
            pageVC.setViewControllers([userVC], direction: .reverse, animated: true, completion: nil)
        }
    }
}

extension ViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is UserViewController {
            return pageVC
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is TransactionViewController {
            return userVC
        }
        
        return nil
    }
    
    
}

