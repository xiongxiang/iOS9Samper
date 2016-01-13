//
//  RootViewCell.swift
//  iOS-9-Sampler
//
//  Created by xiongxiang on 16/1/11.
//  Copyright © 2016年 bearsoft. All rights reserved.
//

import UIKit

class RootViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
