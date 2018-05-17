//
//  TransactionViewController.swift
//  iOS Example
//
//  Created by Duong Khong on 5/17/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import UIKit
import ostkit

class TransactionViewController: UIViewController {
    
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    private var trans: [[String: Any]] = []
    private var services: TransactionTypeServices!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(TransTableViewCell.self)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        services = appDelegate!.sdk.transactionServices()
        
        loadTrans()
    }
    
    private func loadTrans() {
        services.list {
            [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let json):
                if let data = json["data"] as? [String: Any] {
                    strongSelf.trans = data["transaction_types"] as? [[String: Any]] ?? []
                    strongSelf.tableView.reloadData()
                }
                
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    private func execute(_ tran: [String: Any]) {
        
    }
    
    private func create() {
        var kind = TransactionTypeServices.Kind.userToUser
        var type = TransactionTypeServices.CurrencyType.bt
        
        let createTrans = {
            let createTransAlert = UIAlertController(
                title: "create new transaction type",
                message: nil, preferredStyle: .alert
            )
            createTransAlert.addTextField {
                textField in
                textField.placeholder = "Name"
                textField.keyboardType = .default
            }
            createTransAlert.addTextField {
                textField in
                textField.placeholder = "Currency Value"
                textField.keyboardType = .numberPad
            }
            createTransAlert.addTextField {
                textField in
                textField.placeholder = "Commission Percent"
                textField.keyboardType = .numberPad
            }
            createTransAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
                let name = createTransAlert.textFields![0].text ?? ""
                let value = createTransAlert.textFields![1].text ?? ""
                let commission = createTransAlert.textFields![2].text ?? ""
                self.services.create(
                name: name, kind: kind,
                currencyType: type,
                currencyValue: Float(value)!,
                commissionPercent: Float(commission)!) {
                    [weak self] response in
                    guard let strongSelf = self else { return }
                    switch response {
                    case .success(let json):
                        debugPrint(json)
                        strongSelf.loadTrans()
                        
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
            }))
            createTransAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(createTransAlert, animated: true, completion: nil)
        }
        
        let pickType = {
            let typeActionSheet = UIAlertController(
                title: "Which type of currency?",
                message: nil, preferredStyle: .actionSheet
            )
            typeActionSheet.addAction(
                UIAlertAction(
                    title: TransactionTypeServices.CurrencyType.usd.rawValue,
                    style: .default,
                    handler: { action in
                        type = .usd
                        createTrans()
                }))
            
            typeActionSheet.addAction(
                UIAlertAction(
                    title: TransactionTypeServices.CurrencyType.bt.rawValue,
                    style: .default,
                    handler: { action in
                        type = .bt
                        createTrans()
                }))
            typeActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(typeActionSheet, animated: true, completion: nil)
        }
        
        let pickKind = {
            let kindActionSheet = UIAlertController(
                title: "Which kind of transaction?",
                message: nil, preferredStyle: .actionSheet
            )
            kindActionSheet.addAction(
                UIAlertAction(
                    title: TransactionTypeServices.Kind.userToUser.rawValue,
                    style: .default,
                    handler: { action in
                        kind = .userToUser
                        pickType()
                }))
            
            kindActionSheet.addAction(
                UIAlertAction(
                    title: TransactionTypeServices.Kind.userToCompany.rawValue,
                    style: .default,
                    handler: { action in
                        kind = .userToCompany
                        pickType()
                }))
            
            kindActionSheet.addAction(
                UIAlertAction(
                    title: TransactionTypeServices.Kind.companyToUser.rawValue,
                    style: .default,
                    handler: { action in
                        kind = .companyToUser
                        pickType()
                }))
            kindActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(kindActionSheet, animated: true, completion: nil)
        }
        
        pickKind()
        
    }

    @IBAction func buttonCreatePressed(_ sender: Any) {
        create()
    }
}

extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TransTableViewCell
        cell.trans = trans[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tran = trans[indexPath.row]
        execute(tran)
    }
}
