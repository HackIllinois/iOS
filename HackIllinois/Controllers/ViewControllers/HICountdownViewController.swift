//
//  HICountdownViewController.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 1/20/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class HICountdownViewController: UIViewController {

    // MARK: - Properties
    let FRAMES_PER_TICK = 30
    let TOTAL_NUM_FRAMES = 1800
    var hours = LOTAnimationView(name: "Countdown")
    var minutes = LOTAnimationView(name: "Countdown")
    var seconds = LOTAnimationView(name: "Countdown")
    let eventStartUnixTime = 15102379999.0 // TODO: change to needed time
    var timeRemaining = 0.0
    var hoursLeft = 0
    var minutesLeft = 0
    var secondsLeft = 0
    var hourFrame = 0
    var minuteFrame = 0
    var secondFrame = 0
    var diffTime = 0.0
    var timer = Timer()

    // MARK: - Helper functions
    func getHours(timeInSeconds: Double) -> Int {
        let hour = (timeInSeconds / Double(3600)).remainder(dividingBy: 60.0)
        return Int(hour)
    }

    func getMinutes(timeInSeconds: Double) -> Int {
        let minute = ((timeInSeconds.remainder(dividingBy: 3600.0)) / Double(60))
        return Int(minute)
    }

    func getSeconds(timeInSeconds: Double) -> Int {
        let second = ((timeInSeconds.remainder(dividingBy: 3600.0)).remainder(dividingBy: 60.0))
        return Int(second)
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        hours.contentMode = .scaleAspectFit
        minutes.contentMode = .scaleAspectFit
        seconds.contentMode = .scaleAspectFit
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }

}

// MARK: - UIViewController
extension HICountdownViewController {
    override func loadView() {
        view = UIView()

        let countdownStackView = UIStackView()
        countdownStackView.distribution = .fillEqually
        countdownStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countdownStackView)
        countdownStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        countdownStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        countdownStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        countdownStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        countdownStackView.addArrangedSubview(stackView(with: hours, and: "H"))
        countdownStackView.addArrangedSubview(stackView(with: minutes, and: "M"))
        countdownStackView.addArrangedSubview(stackView(with: seconds, and: "S"))
    }

    func stackView(with countDownView: LOTAnimationView, and labelString: String) -> UIStackView {
        let label = UILabel()
        label.text = labelString
        label.textColor = HIColor.hotPink
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 21, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        countDownView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(countDownView)
        stackView.addArrangedSubview(label)

        countDownView.widthAnchor.constraint(equalTo: label.widthAnchor, multiplier: 2).isActive = true

        return stackView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        diffTime = eventStartUnixTime - NSDate().timeIntervalSince1970

        hours.animationSpeed = 2.0
        minutes.animationSpeed = 2.0
        seconds.animationSpeed = 2.0

        hoursLeft = getHours(timeInSeconds: diffTime)
        minutesLeft = getMinutes(timeInSeconds: diffTime)
        secondsLeft = getSeconds(timeInSeconds: diffTime)
        
        if diffTime > 0 {
            hourFrame = (hoursLeft * FRAMES_PER_TICK + TOTAL_NUM_FRAMES) % TOTAL_NUM_FRAMES
            minuteFrame = (minutesLeft * FRAMES_PER_TICK + TOTAL_NUM_FRAMES) % TOTAL_NUM_FRAMES
            secondFrame = (secondsLeft * FRAMES_PER_TICK + TOTAL_NUM_FRAMES) % TOTAL_NUM_FRAMES
        } else {
            hourFrame = 0
            minuteFrame = 0
            secondFrame = 0
        }
        // TODO: ask charlee to set frames such that each number shows up on a (k mod 30) frame where k = currFrame, start at 00 and count up

        hours.setProgressWithFrame(NSNumber(value: hourFrame))
        minutes.setProgressWithFrame(NSNumber(value: minuteFrame))
        seconds.setProgressWithFrame(NSNumber(value: secondFrame))

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if diffTime > 0 {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if timer.isValid {
            timer.invalidate()
        }
    }

    @objc func updateCountdown() {
        if minuteFrame == (TOTAL_NUM_FRAMES - FRAMES_PER_TICK) && secondFrame == (TOTAL_NUM_FRAMES - FRAMES_PER_TICK) {
            hourFrame = (hourFrame - FRAMES_PER_TICK + TOTAL_NUM_FRAMES) % TOTAL_NUM_FRAMES
            hours.play(fromFrame: NSNumber(value: hourFrame + FRAMES_PER_TICK), toFrame: NSNumber(value: hourFrame))
        }

        if secondFrame == (TOTAL_NUM_FRAMES - FRAMES_PER_TICK) {
            minuteFrame = (minuteFrame - FRAMES_PER_TICK + TOTAL_NUM_FRAMES) % TOTAL_NUM_FRAMES
            minutes.play(fromFrame: NSNumber(value: minuteFrame + FRAMES_PER_TICK), toFrame: NSNumber(value: minuteFrame))
        }

        secondFrame = (secondFrame - FRAMES_PER_TICK + TOTAL_NUM_FRAMES) % TOTAL_NUM_FRAMES
        seconds.play(fromFrame: NSNumber(value: secondFrame + FRAMES_PER_TICK), toFrame: NSNumber(value: secondFrame))
        
        print(hourFrame, minuteFrame, secondFrame)
    }
}
