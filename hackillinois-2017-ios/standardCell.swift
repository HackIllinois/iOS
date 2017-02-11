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
    override func prepareForReuse() {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        let imageSize = CGSize(width: 317,height: 164);
        let imageView = UIImageView(frame: CGRect(origin: (self.imageView?.bounds.origin)!, size: imageSize));
//        let imageSize = CGSize(width: 100, height: 50);
//        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: imageSize));
        
        self.contentView.addSubview(imageView);
        let image = drawBorderRectangle(size: imageSize);
        imageView.image = image;
    }
}

