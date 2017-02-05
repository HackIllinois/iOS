//
//  standardCellViewController.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 1/28/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit

class standardCellViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear;
        let k = Plot_Demo(frame: CGRect(x: 75, y: 75, width: 150, height: 150))
        
        // Put the rectangle in the canvas in this new object
        k.draw(CGRect(x: 50, y: 50, width: 100, height: 100))
        k.backgroundColor = UIColor.clear;
        // view: UIView was created earlier using StoryBoard
        // Display the contents (our rectangle) by attaching it
        self.view.addSubview(k)
    }
    
}
