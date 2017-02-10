//
//  BottomViewTableViewCell.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 1/20/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit

class BottomViewTableViewCell: UITableViewCell {
    @IBOutlet weak var dirImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
