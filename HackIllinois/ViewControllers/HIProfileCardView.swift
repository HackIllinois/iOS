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
import URLImage
import HIAPI

// Loads url data and converts into image
extension String {
    func load() -> UIImage {
        do {
            guard let url = URL(string: self) else {
                return UIImage()
            }
            let data: Data = try Data(contentsOf: url)
            return UIImage(data: data) ?? UIImage()
        } catch {}
        return UIImage()
    }
}

struct HIProfileCardView: View {
    let displayName: String
    let points: Int
    let tier: String
    let foodWave: Int
    let avatarUrl: String
    let background = (\HIAppearance.profileCardBackground).value
    let baseText = (\HIAppearance.profileBaseText).value
    let userId: String
    let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    @State var startFetchingQR = false
    @State var qrInfo = ""

    var body: some View {
        ScrollView {
            ZStack {
                ZStack(alignment: .top) {
                    ZStack(alignment: .bottom) {
                        Image("ProfileCardBackground")
                        ZStack {
                            Image("ProfileBanner")
                            VStack(spacing: 0) {
                                Text("Your Ranking")
                                    .foregroundColor(.white)
                                
                                    .font(Font(HIAppearance.Font.profileSubtitle ?? .systemFont(ofSize: 20)))
                                HStack(alignment: .bottom, spacing: 5) {
                                    Image("RankSymbol")
                                    Text("25").foregroundColor(.white).font(Font(HIAppearance.Font.profileSubtitle ?? .systemFont(ofSize: 20)))
                                }
                            }.padding(.bottom, 25)
                        }.alignmentGuide(.bottom) {dimensions in dimensions[.bottom] / 1.2 }
                    }
                    Image(uiImage: avatarUrl.load())
                        .resizable()
                        .frame(width: isIpad ? 149 : 149, height: isIpad ? 170.75 : 170.75)
                        .alignmentGuide(.top) {dimensions in dimensions[VerticalAlignment.center] / 0.9 }
                        .onTapGesture {
                            print(avatarUrl)
                        }
                }
                VStack(spacing: 0) {
                    Spacer().frame(height: 90)
                    Text(formatName())
                        .font(Font(HIAppearance.Font.profileName ?? .systemFont(ofSize: 24)))
                        .foregroundColor(Color((\HIAppearance.countdownTextColor).value))
                        .padding(isIpad ? 32 : 16)
                    HStack(spacing: isIpad ? 16 : 8) {
                        Rectangle()
                            .frame(width: isIpad ? 148 : 74, height: isIpad ? 48 : 24)
                            .cornerRadius(isIpad ? 40 : 20)
                            .foregroundColor(Color(red: 226/255, green: 142/255, blue: 174/255))
                            .overlay(
                                Text(tier)
                                    .font(Font(HIAppearance.Font.profileSubtitle ?? .systemFont(ofSize: 12)))
                                    .foregroundColor(Color(red: 1, green: 248/255, blue: 245/255))
                            )

                        Rectangle()
                            .frame(width: isIpad ? 136 : 68, height: isIpad ? 48 : 24)
                            .cornerRadius(isIpad ? 40 : 20)
                            .foregroundColor(
                                (Color(red: 226/255, green: 142/255, blue: 174/255)))
                            .overlay(
                                Text("Wave \(foodWave)")
                                    .font(Font(HIAppearance.Font.profileSubtitle ?? .systemFont(ofSize: 12)))
                                    .foregroundColor((Color(red: 1, green: 248/255, blue: 245/255)))
                            )
                    }.padding(.bottom)
                    Image(uiImage: UIImage(data: getQRCodeDate(text: qrInfo)!)!)
                                                    .resizable()
                                                    .frame(width: isIpad ? 200 : 221, height: isIpad ? 200 : 221)
                                                    .padding(.bottom, 20)
                }
            }
            .padding(.top, 24)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            startFetchingQR = true
            QRFetchLoop()
        }
        .onDisappear {
            startFetchingQR = false
        }
    }

    func formatName() -> String {
        if displayName.count > 20 {
            let names = displayName.split(separator: " ")
            if names.count >= 2 {
                let firstName = String(names[0])
                let lastName = String(names[1])
                let abbreviatedName = firstName + " " + String(lastName.prefix(1)) + "."
                return abbreviatedName
            } else {
                return displayName
            }
        } else {
            return displayName
        }
    }

    func getQRCodeDate(text: String) -> Data? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = text.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        
        // Change color of QR code
        guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
        colorFilter.setValue(filter.outputImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 1, green: 248/255, blue: 245/255), forKey: "inputColor1") // Background off-white
        colorFilter.setValue(CIColor(red: 102/255, green: 43/255, blue: 19/255), forKey: "inputColor0") // Barcode brown
        
        guard let ciimage = colorFilter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
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
        HIProfileCardView(displayName: "first last",
                          points: 100,
                          tier: "Pro",
                          foodWave: 1,
                          avatarUrl: "https://raw.githubusercontent.com/HackIllinois/adonix-metadata/main/avatars/fishercat.png",
                          userId: "https://www.hackillinois.org"
        )
    }
}
