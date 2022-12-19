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
    let background = (\HIAppearance.profileCardBackground).value
    let baseText = (\HIAppearance.profileBaseText).value
    @State var showingQR = true
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 322, height: 569)
                .cornerRadius(20)
                .foregroundColor(Color(background))
            VStack(spacing: 0) {
                Text("\(firstName) \(lastName)")
                    .foregroundColor(Color(baseText))
                    .padding(16)
                HStack(spacing: 8) {
                    Rectangle()
                        .frame(width: 89, height: 24)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .overlay(
                            Text("\(points) pts")
                                .font(.caption)
                                .foregroundColor(Color(baseText))
                        )
                    Rectangle()
                        .frame(width: 89, height: 24)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .overlay(
                            Text(tier)
                                .font(.caption)
                                .foregroundColor(Color(baseText))
                        )
                }
                
                Image(showingQR ? "TicketBack" : "TicketFront")
                    .onTapGesture {
                        showingQR.toggle()
                    }
                    .padding(24)
                
                VStack(spacing: 16) {
                    Text("Dietary Restrictions")
                    HStack {
                        ForEach(dietaryRestrictions, id: \.self) { diet in
                            Rectangle()
                                .frame(width: 85, height: 24)
                                .cornerRadius(20)
                                .foregroundColor(Color(dietColor(diet: diet)))
                                .padding(.horizontal, 8)
                                .overlay(
                                    Text(diet)
                                        .font(.caption)
                                        .foregroundColor(Color(baseText))
                                )
                        }
                    }
                }
            }
        }
    }
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

struct HIProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        HIProfileCardView(firstName: "first",
                          lastName: "last",
                          dietaryRestrictions: ["vegetarian", "nopeanut"],
                          points: 100,
                          tier: "no tier")
    }
}
