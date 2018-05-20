//
//  UserViewController.swift
//  iOS Example
//
//  Created by Duong Khong on 5/17/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import UIKit
import ostkit

class User {
    var name = ""
    var point = ""
    var uuid = ""
    var actionHandler: ((User)->Void)?
    
    init(dict: [String: Any], handler: ((User)->Void)?) {
        name = dict["name"] as? String ?? ""
        point = dict["token_balance"] as? String ?? ""
        uuid = dict["uuid"] as? String ?? ""
        actionHandler = handler
    }
}

class UserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var users: [User] = []
    private var services: UserServices!
    private var transServices: TransactionTypeServices!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.register(UserTableViewCell.self)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        services = appDelegate!.sdk.userServices()
        transServices = appDelegate!.sdk.transactionServices()
        
        loadUsers()
    }
    
    private func loadUsers() {
        services.list {
            [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let json):
                if let data = json["data"] as? [String: Any] {
                    let userDicts = data["economy_users"] as? [[String: Any]] ?? []
                    debugPrint(userDicts)
                    strongSelf.users = userDicts.map({ User(dict: $0, handler: strongSelf.userActionHanler) })
                    strongSelf.tableView.reloadData()
                }
                
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func userActionHanler(user: User) {
        let alert = UIAlertController(
            title: "Executing reward transaction",
            message: nil,
            preferredStyle: .alert
        )
        present(alert, animated: true, completion: nil)
        let uuid = user.uuid
        let comuuid = COM_UUID
        let kind = "Reward"
        transServices.execute(fromUUID: comuuid, toUUID: uuid, transKind: kind) {
            [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let json):
                debugPrint(json)
                if let _ = json["data"] as? [String: Any] {
                    strongSelf.delay(5) {
                        strongSelf.loadUsers()
                        strongSelf.dismiss(animated: true, completion: nil)
                    }
                }
                
            case .failure(let error):
                debugPrint(error)
                strongSelf.dismiss(animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as UserTableViewCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
