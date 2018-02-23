//
//  HIForceGestureRecognizer.swift
//  HackIllinois
//
//  Created by Kevin Rajan on 2/22/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class HIForceGestureRecognizer: UITapGestureRecognizer {
    public private(set) var force: CGFloat = 0.0
    public var maximumForce: CGFloat = 4.0
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        normalizeForceAndFireEvent(.began, touches: touches)
        
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        normalizeForceAndFireEvent(.changed, touches: touches)
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        normalizeForceAndFireEvent(.ended, touches: touches)
    }
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        normalizeForceAndFireEvent(.cancelled, touches: touches)
    }
    private func normalizeForceAndFireEvent(_ state: UIGestureRecognizerState, touches: Set<UITouch>) {
        guard let firstTouch = touches.first else { return }
        maximumForce = min(firstTouch.maximumPossibleForce, maximumForce)
        force = firstTouch.force / maximumForce
        print("Force: \(force)")
        if force > 0.5 {
            self.state = state
        } else {
            self.state = .cancelled
        }
    }
    public override func reset() {
        super.reset()
        force = 0.0
    }
}
