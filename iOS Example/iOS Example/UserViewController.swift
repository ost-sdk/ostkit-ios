//
//  UserViewController.swift
//  iOS Example
//
//  Created by Duong Khong on 5/17/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import UIKit
import ostkit

class UserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var users: [[String: Any]] = []
    private var services: UserServices!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        services = appDelegate!.sdk.userServices()
        
        loadUsers()
    }
    
    private func loadUsers() {
        services.list {
            [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let json):
                if let data = json["data"] as? [String: Any] {
                    strongSelf.users = data["economy_users"] as? [[String: Any]] ?? []
                    strongSelf.tableView.reloadData()
                }
                
            case .failure(let error):
                debugPrint(error)
            }
        }
    }

    @IBAction func addUser(_ sender: Any) {
        let createUserAlert = UIAlertController(
            title: "create new user",
            message: nil, preferredStyle: .alert
        )
        createUserAlert.addTextField {
            textField in
            textField.placeholder = "Name"
            textField.keyboardType = .default
        }
        createUserAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            let name = createUserAlert.textFields![0].text ?? ""
            self.services.create(name: name) {
                [weak self] response in
                guard let strongSelf = self else { return }
                switch response {
                case .success(let json):
                    debugPrint(json)
                    strongSelf.loadUsers()
                    
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }))
        createUserAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(createUserAlert, animated: true, completion: nil)
    }
    
    @IBAction func sendAirdrop(_ sender: Any) {
        let airdropAlert = UIAlertController(
            title: "send air drop",
            message: nil, preferredStyle: .alert
        )
        airdropAlert.addTextField {
            textField in
            textField.placeholder = "amount"
            textField.keyboardType = .numberPad
        }
        airdropAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            let amount = airdropAlert.textFields![0].text ?? ""
            self.services.airdropDrop(amount: Float(amount)!) {
                [weak self] response in
                guard let strongSelf = self else { return }
                switch response {
                case .success(let json):
                    debugPrint(json)
                    strongSelf.loadUsers()
                    
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }))
        airdropAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(airdropAlert, animated: true, completion: nil)
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        }
        let user = users[indexPath.row]
        cell?.textLabel?.text = user["name"] as? String ?? ""
        cell?.detailTextLabel?.text = user["token_balance"] as? String ?? ""
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
