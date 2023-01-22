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

struct HIProfileCardView: View {
    let firstName: String
    let lastName: String
    let dietaryRestrictions: [String]
    let points: Int
    let tier: String
    let wave: String
    let background = (\HIAppearance.profileCardBackground).value
    let baseText = (\HIAppearance.profileBaseText).value
    let id: String
    let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    @State var showingQR = true
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
                                Text("Wave \(wave)")
                                    .font(Font(HIAppearance.Font.profileSubtitle ?? .systemFont(ofSize: 12)))
                                    .foregroundColor(Color(baseText))
                            )
                    }
                    
                    ZStack {
                        Image(showingQR ? "TicketBack" : "TicketFront")
                            .resizable()
                            .frame(width: isIpad ? 298 : 190.6, height: isIpad ? 544 : 347.67)
                            .padding(isIpad ? 48 : 24)
                        if showingQR {
                            Image(uiImage: UIImage(data: getQRCodeDate(text: id)!)!)
                                .resizable()
                                .frame(width: isIpad ? 200 : 132, height: isIpad ? 200 : 132)
                        }
                    }
                    .onTapGesture {
                        showingQR.toggle()
                    }
                    VStack(spacing: isIpad ? 32 : 16) {
                        Text("Dietary Restrictions")
                            .font(Font(HIAppearance.Font.profileDietaryRestrictions ?? .systemFont(ofSize: 16)))
                        HStack(spacing: isIpad ? 16 : 8) {
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
            .padding(.top, 24)
        }
    }
    
    func getQRCodeDate(text: String) -> Data? {
        print(text)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = text.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
    }
    
    func dietColor(diet: String) -> UIColor {
        switch (diet) {
        case "vegetarian":
            return (\HIAppearance.profileCardVegetarian).value
        case "vegan":
            return UIColor.white
        case "nopeanut":
            return (\HIAppearance.profileCardNut).value
        case "nogluten":
            return UIColor.white
        case "dairy":
            return UIColor.white
        default:
            return UIColor.white
        }
    }
    
    func dietString(diet: String) -> String {
        switch (diet) {
        case "vegetarian":
            return "Vegetarian"
        case "vegan":
            return "Vegan"
        case "nopeanut":
            return "Nut Allergy"
        case "nogluten":
            return "Gluten Free"
        case "dairy":
            return "Dairy Free"
        default:
            return ""
        }
    }
}

struct HIProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        HIProfileCardView(firstName: "first",
                          lastName: "last",
                          dietaryRestrictions: ["vegetarian", "nopeanut"],
                          points: 100,
                          tier: "no tier",
                          wave: "4",
                          id: "https://www.hackillinois.org"
        )
    }
}
