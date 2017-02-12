//
//  twoLocationsCell.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 1/22/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit

class twoLocationsCell: UITableViewCell {

    @IBOutlet weak var checkInTimeLabel: UILabel!
    @IBOutlet weak var firstLocationLabel: UILabel!
    @IBOutlet weak var secondLocationLabel: UILabel!
    @IBOutlet weak var qrCodeButton: UIButton!
    
    let ROW_HEIGHT = 215
    let BUFFER_BETWEEN_CELLS = 15
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageSize = CGSize(width: 317,height: ROW_HEIGHT - BUFFER_BETWEEN_CELLS);
        let imageView = UIImageView(frame: CGRect(origin: (self.imageView?.bounds.origin)!, size: imageSize));
        self.contentView.addSubview(imageView);
        let image = drawBorderRectangle(size: imageSize);
        imageView.image = image;
    }
}
