//
//  standardCell.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 1/22/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//
import UIKit

class standardCell: UITableViewCell {

    @IBOutlet weak var checkInTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var qrCodeButton: UIButton!
    
    let TABLE_VIEW_WIDTH = 317
    let ROW_HEIGHT = 179
    let BUFFER_BETWEEN_CELLS = 15
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // draws border rectangle
        let imageSize = CGSize(width: TABLE_VIEW_WIDTH, height: ROW_HEIGHT - BUFFER_BETWEEN_CELLS);
        let imageView = UIImageView(frame: CGRect(origin: (self.imageView?.bounds.origin)!, size: imageSize));
        self.contentView.addSubview(imageView);
        let image = drawBorderRectangle(size: imageSize);
        imageView.image = image;
    }
}

