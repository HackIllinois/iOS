//
//  HIPointShopSwiftUIView.swift
//  HackIllinois
//
//  Created by HackIllinois on 1/12/24.
//  Copyright © 2024 HackIllinois. All rights reserved.
//

import Foundation
import SwiftUI
import HIAPI

struct HIPointShopSwiftUIView: View {
    @State var items=[] as [Item]
    private var profile = HIProfile()
    @State var coins = 0
    @State var tabIndex = 0
    var body: some View {
        ZStack {
            Image("PurpleBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("KnickKnacks")
                    .resizable()
                    .frame(width: 370, height: 120)
                VStack(spacing: 0) {
                    CustomTopTabBar(tabIndex: $tabIndex)
                    ScrollView(showsIndicators: false) {
                        if tabIndex == 0 {
                            VStack(spacing: 0) {
                                ForEach(0 ..< items.count, id: \.self) {value in
                                    if (items[value].isRaffle==false) {
                                        PointShopItemCell(item: items[value])
                                    }
                                }
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 410, height: 10)
                                    .background(Color(red: 0.4, green: 0.17, blue: 0.07))
                                    .cornerRadius(1)
                            }
                            .onAppear {
                                getItems()
                            }
                        } else {
                            VStack(spacing: 0) {
                                ForEach(0 ..< items.count, id: \.self) {value in
                                    if (items[value].isRaffle==true) {
                                        PointShopItemCell(item: items[value])
                                    }
                                }
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 410, height: 10)
                                    .background(Color(red: 0.4, green: 0.17, blue: 0.07))
                                    .cornerRadius(1)
                            }
                        }
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width - 24, alignment: .center)
                    .padding(.horizontal, 12)
                }
            }
        }
    }
    func getItems() {
        HIAPI.ShopService.getAllItems()
            .onCompletion { [self] result in
                do {
                    let (containedItem, _) = try result.get()
                    let apiItems = containedItem.items
                    items=[]
                    apiItems.forEach { apiItem in
                        items.append(apiItem)
                    }
                } catch {
                    print("Failed to reload points shop with the error: \(error)")
                }
            }
            .launch()
    }
    func getCoins() {
        guard let user = HIApplicationStateController.shared.user else { return }
        HIAPI.ProfileService.getUserProfile()
        .onCompletion { [self] result in
            do {
                let (apiProfile, _) = try result.get()
                print("COINS:", apiProfile.points)
                coins=apiProfile.points
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .loginProfile, object: nil, userInfo: ["profile": self.profile])
                }
            } catch {
                print("Failed to reload coins with the error: \(error)")
            }
        }
        .authorize(with: user)
        .launch()
    }
}

struct PointShopItemCell: View {
    let item: Item
    var body: some View {
        VStack(spacing: 0) {
            //brown bar
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 410, height: 10)
                .background(Color(red: 0.4, green: 0.17, blue: 0.07))
                .cornerRadius(1)
            //transparent pane
            ZStack {
                Rectangle()
                    .fill(.white)
                    .frame(width: 400, height: 157)
                    .opacity(0.4)
                HStack {
                    Spacer()
                    //IMAGE
                    Image("Profile0")
                        .resizable()
                        .frame(width: 145, height: 145)

                    Spacer()
                    //bubble-thing
                    VStack {
                        Text(item.name)
                            .font(
                                Font.custom("Montserrat", size: 16)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0.05, green: 0.25, blue: 0.25))
//                            .frame(width: 130, height: 24)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)

                        HStack(alignment: .center, spacing: 7) {
                            Image("Coin")
                                .resizable()
                                .frame(width: 25, height: 25)
                            if(item.isRaffle) {
                                Text("\(item.price)")
                                    .font(Font.custom("Montserrat", size: 16).weight(.bold))
                                    .foregroundColor(.white)
                            } else {
                                Group {
                                    Text("\(item.price)")
                                        .font(Font.custom("Montserrat", size: 16).weight(.bold))
                                        .foregroundColor(.white) +
                                    Text(" | \(item.quantity) Left")
                                        .font(Font.custom("Montserrat", size: 16).weight(.regular))
                                        .foregroundColor(.white)
                                }
                            }

                        }
                        .padding(.horizontal, 11)
                        .padding(.vertical, 3)
                        .background(Color(red: 0.05, green: 0.25, blue: 0.25).opacity(0.5))
                        .cornerRadius(1000)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct CustomTopTabBar: View {
    @Binding var tabIndex: Int
    var body: some View {
        HStack {
            TabBarButton(text: "MERCH", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
            Spacer()
                .frame(width: 100)
            TabBarButton(text: "RAFFLE", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct TabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        ZStack(alignment: .center) {
            if isSelected {
                Rectangle()
                    .fill(Color(red: 0.85, green: 0.25, blue: 0.47))
                    .frame(width: 165, height: 50)
                    .cornerRadius(10, corners: [.topLeft, .topRight])
            }
            Text(text)
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .font(.custom("MontserratRoman-SemiBold", size: UIDevice.current.userInterfaceIdiom == .pad ? 36 : 18))
                .padding(.bottom, 10)
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
