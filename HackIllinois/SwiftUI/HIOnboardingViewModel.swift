//
//  HIOnboardingViewModel.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 10/30/22.
//  Copyright © 2022 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import SwiftUI

class HIOnboardingViewModel: ObservableObject {
    @Published var data: [CarouselData] = UIDevice.current.userInterfaceIdiom == .pad ? [
        CarouselData(image: #imageLiteral(resourceName: "Onboarding0"), titleText: "Welcome!", descriptionText: "Swipe to see what our app has to offer!"),
        CarouselData(image: UIImage(named: "iPadOnboarding0"), titleText: "Home", descriptionText: "See how much time you have left to hack!"),
        CarouselData(image: UIImage(named: "iPadOnboarding1"), titleText: "Schedule", descriptionText: "See the times and details of all of our events."),
        CarouselData(image: UIImage(named: "iPadOnboarding2"), titleText: "Scan for Points", descriptionText: "Scan QR codes at events to obtain points!"),
        CarouselData(image: UIImage(named: "iPadOnboarding3"), titleText: "Profile", descriptionText: "View your points, tier, and other personal information."),
        CarouselData(image: UIImage(named: "iPadOnboarding4"), titleText: "Leaderboard", descriptionText: "See who is leading HackIllinois 2022 in points earned!")
    ] : [
        CarouselData(image: #imageLiteral(resourceName: "Onboarding0"), titleText: "Welcome!", descriptionText: "Swipe to see what our app has to offer!"),
        CarouselData(image: UIImage(named: "Onboarding1"), titleText: "Home", descriptionText: "See how much time you have left to hack!"),
        CarouselData(image: UIImage(named: "Onboarding2"), titleText: "Schedule", descriptionText: "See the times and details of all of our events."),
        CarouselData(image: UIImage(named: "Onboarding3"), titleText: "Scan for Points", descriptionText: "Scan QR codes at events to obtain points!"),
        CarouselData(image: UIImage(named: "Onboarding4"), titleText: "Profile", descriptionText: "View your points, tier, and other personal information."),
        CarouselData(image: UIImage(named: "Onboarding5"), titleText: "Leaderboard", descriptionText: "See who is leading HackIllinois 2022 in points earned!")
    ]
    @Published var shouldDisplayAnimationOnNextAppearance = true
}
