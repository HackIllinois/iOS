//
//  noEventCell.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 2/5/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit

class noEventCell: UITableViewCell {
    let ROW_HEIGHT = 120
    // no buffer between cell needed because no event cell will not be followed by other cells
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let imageSize = CGSize(width: 317,height: ROW_HEIGHT);
        let imageView = UIImageView(frame: CGRect(origin: (self.imageView?.bounds.origin)!, size: imageSize));
        
        self.contentView.addSubview(imageView);
        let image = drawBorderRectangle(size: imageSize);
        imageView.image = image;
    }
    
}
