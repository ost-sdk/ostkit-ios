//
//  TransTableViewCell.swift
//  iOS Example
//
//  Created by Duong Khong on 5/17/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import UIKit

class TransTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    var trans: [String: Any]? {
        didSet {
            guard let trans = trans else { return }
            nameLabel.text = trans["name"] as? String ?? ""
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
