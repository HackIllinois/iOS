//
//  LOTAnimationView.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/5/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Lottie

extension LOTAnimationView {
    func setProgress(frame: Int) {
        setProgressWithFrame(NSNumber(value: frame))
    }

    func play(from startFrame: Int, to endFrame: Int) {
        play(fromFrame: NSNumber(value: startFrame), toFrame: NSNumber(value: endFrame))
    }
}
