//
//  HICarouselSwiftUIView.swift
//  HackIllinois
//
//  Created by Louis Qian on 10/29/22.
//  Copyright © 2022 HackIllinois. All rights reserved.
//

import Foundation
import SwiftUI

struct CarouselData: Hashable{
    let image: UIImage?
    let titleText: String
    let descriptionText: String
}

struct HICarouselSwiftUIView: View {
    var carouselData : [CarouselData]
    
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
                        .multilineTextAlignment(.center)
                }
            }
        }.tabViewStyle(.page)
            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 500: 300)
    }
}
// MARK: - SwiftUI => HILabel
struct HILableSUI : UIViewRepresentable {
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
