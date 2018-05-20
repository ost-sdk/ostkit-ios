//
//  UserTableViewCell.swift
//  iOS Example
//
//  Created by Duong Khong on 5/20/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPoint: UILabel!
    
    
    var user: User? {
        didSet {
            labelName.text = user?.name
            labelPoint.text = user?.point
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonSendPressed(_ sender: Any) {
        guard let user = user else { return }
        user.actionHandler?(user)
    }
    
}
