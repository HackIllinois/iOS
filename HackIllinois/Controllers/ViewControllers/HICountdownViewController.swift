//
//  HICountdownViewController.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 1/20/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import Lottie

protocol HICountdownViewControllerDelegate: class {
    func countdownToDateFor(countdownViewController: HICountdownViewController) -> Date?
}

class HICountdownViewController: UIViewController {

    // MARK: - Constants
    let FRAMES_PER_TICK = 30
    let TOTAL_NUM_FRAMES = 1800

    // MARK: - Properties
    var days = LOTAnimationView(name: "countdown-60")
    var hours = LOTAnimationView(name: "countdown-24")
    var minutes = LOTAnimationView(name: "countdown-60")
    var seconds = LOTAnimationView(name: "countdown-60")

    var countdownDate: Date?
    var dayFrame = 0
    var hourFrame = 0
    var minuteFrame = 0
    var secondFrame = 0
    var timer: Timer?

    var timeDifference: TimeInterval = 0.0
    var daysRemaining: Int {
        return max(0, Int(timeDifference / Date.DAY_IN_SECONDS) % 60)
    }

    var hoursRemaining: Int {
        return max(0, Int(timeDifference / Date.HOUR_IN_SECONDS) % 24)
    }

    var minutesRemaining: Int {
        return max(0, Int(timeDifference / Date.MINUTE_IN_SECONDS) % 60)
    }

    var secondsRemaining: Int {
        return max(0, Int(timeDifference) % 60)
    }

    weak var delegate: HICountdownViewControllerDelegate?

    // MARK: - Init
    convenience init(delegate: HICountdownViewControllerDelegate) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
        refreshForThemeChange()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Themeable
    @objc func refreshForThemeChange() {
        days.backgroundColor = HIAppearance.current.background
        hours.backgroundColor = HIAppearance.current.background
        minutes.backgroundColor = HIAppearance.current.background
        seconds.backgroundColor = HIAppearance.current.background
    }
}

// MARK: - UIViewController
extension HICountdownViewController {
    override func loadView() {
        view = HIView(style: .background)

        days.contentMode = .scaleAspectFit
        hours.contentMode = .scaleAspectFit
        minutes.contentMode = .scaleAspectFit
        seconds.contentMode = .scaleAspectFit

        days.animationSpeed = 2.0
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

        countdownStackView.addArrangedSubview(stackView(with: days, and: "D"))
        countdownStackView.addArrangedSubview(stackView(with: hours, and: "H"))
        countdownStackView.addArrangedSubview(stackView(with: minutes, and: "M"))
        countdownStackView.addArrangedSubview(stackView(with: seconds, and: "S"))
    }

    func stackView(with countDownView: LOTAnimationView, and labelString: String) -> UIStackView {
        countDownView.backgroundColor = HIAppearance.current.background
        countDownView.translatesAutoresizingMaskIntoConstraints = false

        let label = HILabel(style: .countdown(text: labelString))

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
        startUpCountdown()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tearDownCountdown()
    }
}

extension HICountdownViewController {
    func startUpCountdown() {
        countdownDate = delegate?.countdownToDateFor(countdownViewController: self)
        updateTimeDifference()
        setupCounters()
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateCountdown),
            userInfo: nil,
            repeats: true
        )
    }

    func setupCounters() {
        dayFrame = daysRemaining * FRAMES_PER_TICK
        hourFrame = hoursRemaining * FRAMES_PER_TICK
        minuteFrame = minutesRemaining * FRAMES_PER_TICK
        secondFrame = secondsRemaining * FRAMES_PER_TICK

        days.setProgress(frame: dayFrame)
        hours.setProgress(frame: hourFrame)
        minutes.setProgress(frame: minuteFrame)
        seconds.setProgress(frame: secondFrame)
    }

    @objc func updateCountdown() {
        updateTimeDifference()
        guard timeDifference > 0 else {
            countdownDate = delegate?.countdownToDateFor(countdownViewController: self)
            return
        }

        let daysEndFrame = daysRemaining * FRAMES_PER_TICK
        let daysStartFrame = daysEndFrame + FRAMES_PER_TICK
        if dayFrame != daysEndFrame {
            dayFrame = daysEndFrame
            days.play(from: daysStartFrame, to: daysEndFrame)
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
        timeDifference = countdownDate?.timeIntervalSince(Date()) ?? 0
    }

    func tearDownCountdown() {
        timer?.invalidate()
        timer = nil
    }
}
