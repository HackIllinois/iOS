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

struct HIOnboardingView: View {
    
    @StateObject private var viewModel = HIOnboardingViewModel()
    
    var body: some View {
        ZStack {
            Image("Login")
                .resizable()
                .ignoresSafeArea()
                .zIndex(-1)
            if viewModel.shouldDisplayAnimationOnNextAppearance {
                LottieView(shouldDisplayAnimationOnNextAppearance: $viewModel.shouldDisplayAnimationOnNextAppearance)
            } else {
                VStack {
                    Spacer()
                    
                    HICarouselSwiftUIView(carouselData: viewModel.data)
                    
                    Button("Get Started") {
                        NotificationCenter.default.post(name: .getStarted, object: nil)
                    }
                    .padding()
                    .font(.title3.bold())
                    .frame(width: 350, height: 50)
                    .foregroundColor(.white)
                    .background(Color(red: 130/255, green: 171/255, blue: 79/255))
                    .clipShape(Capsule())
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - SwiftUI => LottieView
struct LottieView: UIViewRepresentable {
    
    @Binding var shouldDisplayAnimationOnNextAppearance : Bool
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = AnimationView(name: "DarkVespaText")
        animationView.contentMode = .scaleAspectFit
        animationView.frame = view.frame
        animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(animationView)
        animationView.play { _ in
            withAnimation(.easeInOut(duration: 1)) {
                shouldDisplayAnimationOnNextAppearance.toggle()
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { return }
}

struct HIOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        HIOnboardingView()
    }
}
