//
//  LOTAnimationView.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/5/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
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
