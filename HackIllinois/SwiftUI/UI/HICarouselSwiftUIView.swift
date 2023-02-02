//
//  HICarouselSwiftUIView.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 10/29/22.
//  Copyright © 2022 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import SwiftUI

struct CarouselData: Hashable {
    let image: UIImage?
    let titleText: String
    let descriptionText: String
}

struct HICarouselSwiftUIView: View {
    var carouselData: [CarouselData]
    var body: some View {
        TabView {
            ForEach(carouselData, id: \.self) { carousel in
                VStack {
                    Image(uiImage: carousel.image!)
                        .resizable()
                        .scaledToFit()
                        .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 600: 360)
                        .padding()
                    HILableSUI(text: carousel.titleText, style: .onboardingTitle)
                        .frame(width: 20, height: 20)
                    Text(carousel.descriptionText)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
            }
        }.tabViewStyle(.page)
            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 500: 300)
    }
}
// MARK: - SwiftUI => HILabel
struct HILableSUI: UIViewRepresentable {
    var text: String
    var style: HILabel.Style?
    func makeUIView(context: Context) -> UILabel {
        let label = HILabel(style: style)
        label.text = text
        return label
    }
    func updateUIView(_ uiView: UILabel, context: Context) {
        return
    }
}

//struct CarouselSwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        HICarouselSwiftUIView()
//    }
//}
