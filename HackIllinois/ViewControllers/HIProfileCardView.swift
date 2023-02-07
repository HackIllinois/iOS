//
//  HIProfileViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/30/22.
//  Copyright © 2022 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import SwiftUI
import HIAPI

struct HIProfileCardView: View {
    let firstName: String
    let lastName: String
    let dietaryRestrictions: [String]
    let points: Int
    let tier: String
    let foodWave: Int
    let background = (\HIAppearance.profileCardBackground).value
    let baseText = (\HIAppearance.profileBaseText).value
    let id: String
    let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    @State var flipped: Bool = false
    @State var ticketRotation = 0.0
    @State var contentRotation = 0.0
    @State var flipping = false
    @State var startFetchingQR = false
    @State var qrInfo = ""

    var body: some View {
        ScrollView {
            ZStack {
                Rectangle()
                    .frame(width: isIpad ? UIScreen.main.bounds.width - 56 * 2 : UIScreen.main.bounds.width - 32 * 2 ,
                           height: isIpad ? 978 : 569)
                    .cornerRadius(UIDevice.current.userInterfaceIdiom == .pad ? 40 : 20)
                    .foregroundColor(Color(background))
                VStack(spacing: 0) {
                    Text("\(firstName) \(lastName)")
                        .font(Font(HIAppearance.Font.profileName ?? .systemFont(ofSize: 20)))
                        .foregroundColor(Color(baseText))
                        .padding(isIpad ? 32 : 16)
                    HStack(spacing: isIpad ? 16 : 8) {
                        Rectangle()
                            .frame(width: isIpad ? 146 : 73, height: isIpad ? 48 : 24)
                            .cornerRadius(isIpad ? 40 : 20)
                            .foregroundColor(.white)
                            .overlay(
                                Text("\(points) pts")
                                    .font(Font(HIAppearance.Font.profileSubtitle ?? .systemFont(ofSize: 12)))
                                    .foregroundColor(Color(baseText))
                            )
                        Rectangle()
                            .frame(width: isIpad ? 204 : 102, height: isIpad ? 48 : 24)
                            .cornerRadius(isIpad ? 40 : 20)
                            .foregroundColor(.white)
                            .overlay(
                                Text(tier)
                                    .font(Font(HIAppearance.Font.profileSubtitle ?? .systemFont(ofSize: 12)))
                                    .foregroundColor(Color(baseText))
                            )

                        Rectangle()
                            .frame(width: isIpad ? 136 : 68, height: isIpad ? 48 : 24)
                            .cornerRadius(isIpad ? 40 : 20)
                            .foregroundColor(.white)
                            .overlay(
                                Text("Wave \(foodWave)")
                                    .font(Font(HIAppearance.Font.profileSubtitle ?? .systemFont(ofSize: 12)))
                                    .foregroundColor(Color(baseText))
                            )
                    }
                    ZStack {
                        if flipped {
                            ZStack {
                                Image("TicketBack")
                                    .resizable()
                                    .frame(width: isIpad ? 298 : 190.6, height: isIpad ? 544 : 347.67)
                                    .padding(isIpad ? 48 : 24)
                                Image(uiImage: UIImage(data: getQRCodeDate(text: qrInfo)!)!)
                                    .resizable()
                                    .frame(width: isIpad ? 200 : 132, height: isIpad ? 200 : 132)
                            }
                        } else {
                            Image("TicketFront")
                                .resizable()
                                .frame(width: isIpad ? 298 : 190.6, height: isIpad ? 544 : 347.67)
                                .padding(isIpad ? 48 : 24)
                        }
                    }
                    .rotation3DEffect(.degrees(contentRotation), axis: (x: 0, y: 1, z: 0))
                    .onTapGesture {
                        if !flipping {
                            flipFlashcard()
                        }
                    }
                    .rotation3DEffect(.degrees(ticketRotation), axis: (x: 0, y: 1, z: 0))

                    VStack(spacing: isIpad ? 32 : 16) {
                        Text("Dietary Restrictions")
                            .font(Font(HIAppearance.Font.profileDietaryRestrictions ?? .systemFont(ofSize: 16)))
                        HStack(spacing: isIpad ? 16 : 8) {
                            if dietaryRestrictions.isEmpty {
                                Rectangle()
                                    .frame(width: isIpad ? 204 : 92, height: isIpad ? 48 : 24)
                                    .cornerRadius(isIpad ? 40 : 20)
                                    .foregroundColor(Color(dietColor(diet: "None")))
                                    .overlay(
                                        Text("None")
                                            .font(Font(HIAppearance.Font.profileDietaryRestrictionsLabel ?? .systemFont(ofSize: 12)))
                                            .foregroundColor(.white)
                                    )
                            } else {
                                ForEach(dietaryRestrictions, id: \.self) { diet in
                                    Rectangle()
                                        .frame(width: isIpad ? 204 : 92, height: isIpad ? 48 : 24)
                                        .cornerRadius(isIpad ? 40 : 20)
                                        .foregroundColor(Color(dietColor(diet: diet)))
                                        .overlay(
                                            Text(dietString(diet: diet))
                                                .font(Font(HIAppearance.Font.profileDietaryRestrictionsLabel ?? .systemFont(ofSize: 12)))
                                                .foregroundColor(Color(baseText))
                                        )
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 24)
        }
        .onAppear {
            startFetchingQR = true
            QRFetchLoop()
        }
        .onDisappear {
            startFetchingQR = false
        }
    }

    func getQRCodeDate(text: String) -> Data? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = text.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
    }

    func dietString(diet: String) -> String {
        switch (diet) {
        case "Vegetarian":
            return "Vegetarian"
        case "Vegan":
            return "Vegan"
        case "Gluten-Free":
            return "Gluten-Free"
        case "Lactose-Intolerant":
            return "Dairy Free"
        case "Other":
            return "Other"
        case "None":
            return "None"
        case "":
            return ""
        default:
            return ""
        }
    }

    func dietColor(diet: String) -> UIColor {
        switch (diet) {
        case "Vegetarian":
            return (\HIAppearance.profileCardVegetarian).value
        case "Vegan":
            return (\HIAppearance.profileCardVegan).value
        case "Gluten-Free":
            return (\HIAppearance.profileCardGlutenFree).value
        case "Lactose-Intolerant":
            return (\HIAppearance.profileCardLactoseIntolerant).value
        case "Other":
            return (\HIAppearance.profileCardOther).value
        case "None":
            return (\HIAppearance.profileCardNone).value
        case "":
            return (\HIAppearance.profileCardNone).value
        default:
            return (\HIAppearance.profileCardNone).value
        }
    }

    func flipFlashcard() {
        let animationTime = 0.5
        flipping = true
        withAnimation(Animation.linear(duration: animationTime)) {
            ticketRotation += 180
            flipping = false
        }
        withAnimation(Animation.linear(duration: 0.001).delay(animationTime / 2)) {
            contentRotation += 180
            flipped.toggle()
        }
    }

    func QRFetchLoop() {
        if startFetchingQR {
            getQRInfo()
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                QRFetchLoop()
            }
        }
    }

    func getQRInfo() {
        guard let user = HIApplicationStateController.shared.user else { return }

        HIAPI.UserService.getQR()
            .onCompletion { result in
                do {
                    let (qr, _) = try result.get()
                    DispatchQueue.main.async {
                        self.qrInfo = qr.qrInfo
                    }
                } catch {
                    print("An error has occurred \(error)")
                }
            }
            .authorize(with: user)
            .launch()
    }
}

struct HIProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        HIProfileCardView(firstName: "first",
                          lastName: "last",
                          dietaryRestrictions: ["vegetarian", "nopeanut"],
                          points: 100,
                          tier: "no tier",
                          foodWave: 1,
                          id: "https://www.hackillinois.org"
        )
    }
}
