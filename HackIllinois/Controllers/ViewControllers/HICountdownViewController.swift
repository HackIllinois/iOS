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

    // MARK: - Constants
    let FRAMES_PER_TICK = 30
    let TOTAL_NUM_FRAMES = 1800

    // MARK: - Properties
    var hours = LOTAnimationView(name: "countdown")
    var minutes = LOTAnimationView(name: "countdown")
    var seconds = LOTAnimationView(name: "countdown")

    // TODO: change to needed time
    let countdownDate = Date(timeIntervalSince1970: 1517942500)
    var hourFrame = 0
    var minuteFrame = 0
    var secondFrame = 0
    var timer = Timer()

    var timeDifference: TimeInterval = 0.0
    var hoursRemaining: Int {
        return max(0, Int(timeDifference / 3600) % 60)
    }

    var minutesRemaining: Int {
        return max(0, Int(timeDifference / 60) % 60)
    }

    var secondsRemaining: Int {
        return max(0, Int(timeDifference) % 60)
    }
}

// MARK: - UIViewController
extension HICountdownViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HICountdownViewController.handleApplicationDidBecomeActive(notification:)),
                                               name: Notification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
    }

    override func loadView() {
        view = UIView()

        hours.contentMode = .scaleAspectFit
        minutes.contentMode = .scaleAspectFit
        seconds.contentMode = .scaleAspectFit

        hours.animationSpeed = 2.0
        minutes.animationSpeed = 2.0
        seconds.animationSpeed = 2.0

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

        countDownView.widthAnchor.constraint(equalTo: label.widthAnchor, multiplier: 2.3).isActive = true

        return stackView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateTimeDifference()
        setupCounters()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(HICountdownViewController.updateCountdown),
                                     userInfo: nil,
                                     repeats: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if timer.isValid {
            timer.invalidate()
        }
    }
}

extension HICountdownViewController {
    @objc func handleApplicationDidBecomeActive(notification: Notification) {
        updateTimeDifference()
        setupCounters()
    }

    func setupCounters() {
        hourFrame = hoursRemaining * FRAMES_PER_TICK
        minuteFrame = minutesRemaining * FRAMES_PER_TICK
        secondFrame = secondsRemaining * FRAMES_PER_TICK

        hours.setProgress(frame: hourFrame)
        minutes.setProgress(frame: minuteFrame)
        seconds.setProgress(frame: secondFrame)
    }

    @objc func updateCountdown() {
        updateTimeDifference()
        guard timeDifference > 0 else {
            timer.invalidate()
            return
        }

        let hoursEndFrame = hoursRemaining * FRAMES_PER_TICK
        let hoursStartFrame = hoursEndFrame + FRAMES_PER_TICK
        if hourFrame != hoursEndFrame {
            hourFrame = hoursEndFrame
            hours.play(from: hoursStartFrame, to: hoursEndFrame)
        }

        let minutesEndFrame = minutesRemaining * FRAMES_PER_TICK
        let minutesStartFrame = minutesEndFrame + FRAMES_PER_TICK
        if minuteFrame != minutesEndFrame {
            minuteFrame = minutesEndFrame
            minutes.play(from: minutesStartFrame, to: minutesEndFrame)
        }

        let secondsEndFrame = secondsRemaining * FRAMES_PER_TICK
        let secondsStartFrame = secondsEndFrame + FRAMES_PER_TICK
        if secondFrame != secondsEndFrame {
            secondFrame = secondsEndFrame
            seconds.play(from: secondsStartFrame, to: secondsEndFrame)
        }
    }

    func updateTimeDifference() {
        timeDifference = countdownDate.timeIntervalSince(Date())
        print("--- time info ---")
        print(timeDifference)
        print(hoursRemaining, minutesRemaining, secondsRemaining)
    }
}
