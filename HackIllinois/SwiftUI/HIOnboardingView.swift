//
//  HIOnboardingView.swift
//  HackIllinois
//
//  Created by Louis Qian on 10/29/22.
//  Copyright © 2022 HackIllinois. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import Lottie

@available(iOS 14.0, *)
struct HIOnboardingView: View {
    
    var data : [CarouselData] = UIDevice.current.userInterfaceIdiom == .pad ? [
        CarouselData(image: #imageLiteral(resourceName: "Onboarding0"), titleText: "Welcome!", descriptionText: "Swipe to see what our app has to offer!"),
        CarouselData(image: UIImage(named: "iPadOnboarding0"), titleText: "Countdown", descriptionText: "See how much time you have left to hack!"),
        CarouselData(image: UIImage(named: "iPadOnboarding1"), titleText: "Schedule", descriptionText: "See the times and details of all of our events."),
        CarouselData(image: UIImage(named: "iPadOnboarding2"), titleText: "Scan for Points", descriptionText: "Scan QR codes at events to obtain points!"),
        CarouselData(image: UIImage(named: "iPadOnboarding3"), titleText: "Profile", descriptionText: "View your points, tier, and other personal information."),
        CarouselData(image: UIImage(named: "iPadOnboarding4"), titleText: "Leaderboard", descriptionText: "See who is leading HackIllinois 2022 in points earned!"),
    ] : [
        CarouselData(image: #imageLiteral(resourceName: "Onboarding0"), titleText: "Welcome!", descriptionText: "Swipe to see what our app has to offer!"),
        CarouselData(image: UIImage(named: "Onboarding1"), titleText: "Countdown", descriptionText: "See how much time you have left to hack!"),
        CarouselData(image: UIImage(named: "Onboarding2"), titleText: "Schedule", descriptionText: "See the times and details of all of our events."),
        CarouselData(image: UIImage(named: "Onboarding3"), titleText: "Scan for Points", descriptionText: "Scan QR codes at events to obtain points!"),
        CarouselData(image: UIImage(named: "Onboarding4"), titleText: "Profile", descriptionText: "View your points, tier, and other personal information."),
        CarouselData(image: UIImage(named: "Onboarding5"), titleText: "Leaderboard", descriptionText: "See who is leading HackIllinois 2022 in points earned!"),
    ]
    @State var shouldDisplayAnimationOnNextAppearance = true
    
    var body: some View {
        ZStack {
            Image("Login")
                .resizable()
                .ignoresSafeArea()
            if shouldDisplayAnimationOnNextAppearance {
                LottieView()
                    .onAppear{
                    Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
                        withAnimation(.easeInOut(duration: 1)) {
                            self.shouldDisplayAnimationOnNextAppearance.toggle()
                        }
                    }
                }
            } else {
                VStack {
                    Spacer()
                    HICarouselSwiftUIView(carouselData: data)
                    HIButtonSUI()
                        .frame(width: 350, height: 50)
                        .onTapGesture {
                            NotificationCenter.default.post(name: .getStarted, object: nil)
                        }
                    Spacer()
                }
            }
            
        }
    }
}

// MARK: - SwiftUI => LottieView
@available(iOS 14.0, *)
struct LottieView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = AnimationView(name: "DarkVespaText")
        animationView.contentMode = .scaleAspectFit
        animationView.frame = view.frame
        animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(animationView)
        animationView.play()
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { return }
}



// MARK: - SwiftUI => HIButton
@available(iOS 14.0, *)
struct HIButtonSUI : UIViewRepresentable {
    func makeUIView(context: Context) -> UIButton {
        let startButton = HIButton {
            $0.layer.cornerRadius = 25
            $0.titleLabel?.font = HIAppearance.Font.onboardingGetStartedText
            $0.backgroundHIColor = \.buttonViewBackground
            $0.titleHIColor = \.whiteText
            $0.title = "Get Started"
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        return startButton
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) { return }
}

@available(iOS 14.0, *)
struct HIOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        HIOnboardingView()
    }
}
