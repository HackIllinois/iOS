//
//  HICountdownViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/20/18.
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
    private let FRAMES_PER_TICK = 30
    private let TOTAL_NUM_FRAMES = 1800

    // MARK: - Properties
    private let days = AnimationView(name: "countdown-60")
    private let hours = AnimationView(name: "countdown-24")
    private let minutes = AnimationView(name: "countdown-60")
    private let seconds = AnimationView(name: "countdown-60")
    private let backgroundHIColor: HIColor = \.clear

    private var countdownDate: Date?
    private var dayFrame = 0
    private var hourFrame = 0
    private var minuteFrame = 0
    private var secondFrame = 0
    private var timer: Timer?

    private var timeDifference: TimeInterval = 0.0
    private var daysRemaining: Int { return max(0, Int(timeDifference / Date.DAY_IN_SECONDS) % 60) }
    private var hoursRemaining: Int { return max(0, Int(timeDifference / Date.HOUR_IN_SECONDS) % 24) }
    private var minutesRemaining: Int { return max(0, Int(timeDifference / Date.MINUTE_IN_SECONDS) % 60) }
    private var secondsRemaining: Int { return max(0, Int(timeDifference) % 60) }

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

    private let countdownFillColor: HIColor = \.baseText
    private var countdownFillColorCallback: ColorValueProvider?

    // MARK: - Themeable
    @objc func refreshForThemeChange() {
        days.backgroundColor <- backgroundHIColor
        hours.backgroundColor <- backgroundHIColor
        minutes.backgroundColor <- backgroundHIColor
        seconds.backgroundColor <- backgroundHIColor

        let fillColorKeypath = AnimationKeypath(keypath: "**.Fill 1.Color")
        let countdownFillColorCallback = ColorValueProvider { _ in self.countdownFillColor.value.lottieColorValue }
        self.countdownFillColorCallback = countdownFillColorCallback

        days.setValueProvider(countdownFillColorCallback, keypath: fillColorKeypath)
        hours.setValueProvider(countdownFillColorCallback, keypath: fillColorKeypath)
        minutes.setValueProvider(countdownFillColorCallback, keypath: fillColorKeypath)
        seconds.setValueProvider(countdownFillColorCallback, keypath: fillColorKeypath)
    }
}

// MARK: - UIViewController
extension HICountdownViewController {
    override func loadView() {
        view = HIView { $0.backgroundHIColor = \.clear }

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

    func stackView(with countDownView: AnimationView, and labelString: String) -> UIStackView {
        countDownView.backgroundColor <- backgroundHIColor
        countDownView.translatesAutoresizingMaskIntoConstraints = false

        let label = HILabel {
            $0.textHIColor = \.accent
            $0.backgroundHIColor = \.clear
            $0.textAlignment = .center
            $0.font = HIAppearance.Font.glyph
            $0.text = labelString
        }

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
        let timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateCountdown),
            userInfo: nil,
            repeats: true
        )
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    func setupCounters() {
        days.currentFrame = CGFloat(daysRemaining * FRAMES_PER_TICK)
        hours.currentFrame = CGFloat(hoursRemaining * FRAMES_PER_TICK)
        minutes.currentFrame = CGFloat(minutesRemaining * FRAMES_PER_TICK)
        seconds.currentFrame = CGFloat(secondsRemaining * FRAMES_PER_TICK)
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
            days.play(fromFrame: CGFloat(daysStartFrame), toFrame: CGFloat(daysEndFrame))
        }

        let hoursEndFrame = hoursRemaining * FRAMES_PER_TICK
        let hoursStartFrame = hoursEndFrame + FRAMES_PER_TICK
        if hourFrame != hoursEndFrame {
            hourFrame = hoursEndFrame
            hours.play(fromFrame: CGFloat(hoursStartFrame), toFrame: CGFloat(hoursEndFrame))
        }

        let minutesEndFrame = minutesRemaining * FRAMES_PER_TICK
        let minutesStartFrame = minutesEndFrame + FRAMES_PER_TICK
        if minuteFrame != minutesEndFrame {
            minuteFrame = minutesEndFrame
            minutes.play(fromFrame: CGFloat(minutesStartFrame), toFrame: CGFloat(minutesEndFrame))
        }

        let secondsEndFrame = secondsRemaining * FRAMES_PER_TICK
        let secondsStartFrame = secondsEndFrame + FRAMES_PER_TICK
        if secondFrame != secondsEndFrame {
            secondFrame = secondsEndFrame
            seconds.play(fromFrame: CGFloat(secondsStartFrame), toFrame: CGFloat(secondsEndFrame))
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
