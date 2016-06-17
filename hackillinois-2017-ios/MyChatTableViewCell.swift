//
//  MyChatTableViewCell.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/17/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class MyChatTableViewCell: UITableViewCell {
    @IBOutlet weak var chatLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
