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
    @State private var profile = HIProfile()
    @State var coins = 0
    @State var tabIndex = 0
    let isIpad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
      //  NavigationStack{

        ZStack {
            Image("PurpleBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack{
                        
                        HStack(alignment: .center, spacing: 7) {
                            Image("Coin")
                                .resizable()
                                .frame(width: 25, height: 25)
                            
                            Text("\(coins)")
                                .font(Font.custom("Montserrat", size: 16).weight(.bold))
                                .foregroundColor(.white)

                        }
                        .padding(.horizontal, 11)
                        .padding(.vertical, 3)
                        .background(Color(red: 0.05, green: 0.25, blue: 0.25).opacity(0.5))
                        .cornerRadius(1000)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .offset(y: -35)
    
                        Spacer()
                    }
                    Image("KnickKnacks")
                        .resizable()
                        .frame(width: isIpad ? 590 : 370, height:isIpad ? 191 :  120)
                    Spacer()
                        .frame(height:50)
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
                                        .frame(width: isIpad ? 600 : 380, height: 10)
                                        .background(Color(red: 0.4, green: 0.17, blue: 0.07))
                                        .cornerRadius(1)
                                }
                                .onAppear {
                                    getItems()
                                    getCoins{coins in
                                             self.coins=coins}
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
                                        .frame(width: isIpad ? 600 : 380, height: 10)
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
        //}
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
    func getCoins(completion: @escaping (Int) -> Void) {
        guard let user = HIApplicationStateController.shared.user else { return }
        HIAPI.ProfileService.getUserProfile(userToken: user.token)
        .onCompletion { result in
            do {
                let (apiProfile, _) = try result.get()
                completion(apiProfile.coins)
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
    let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        VStack(spacing: 0) {
            //brown bar
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: isIpad ? 600 : 380, height: 10)//TODO: Change width
                .background(Color(red: 0.4, green: 0.17, blue: 0.07))
                .cornerRadius(1)
            //transparent pane
            ZStack {
                Rectangle()
                    .fill(.white)
                    .frame(width: isIpad ? 590 : 370, height: 157)//TODO: Change width
                    .opacity(0.4)
                HStack {
                    Spacer()
                        .frame(width:isIpad ? 120 : 50)
                    //IMAGE
                        Image(systemName: "Profile0")
                            .data(url: URL(string: item.imageURL)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 145, height: 145)
                    Spacer()

                    //bubble-thing
                    VStack {
                        HStack{
                            Text(item.name)
                                .font(
                                    Font.custom("Montserrat", size: 16)
                                        .weight(.semibold)
                                )
                                .foregroundColor(Color(red: 0.05, green: 0.25, blue: 0.25))
                            //                            .frame(width: 130, height: 24)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                            Spacer()
                                .frame(width:20)
                        }

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
//                            Spacer()
//                                .frame(width:20)

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
    let isIpad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        HStack {
            TabBarButton(text: "MERCH", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
            Spacer()
                .frame(width: isIpad ? 100: 40)
            TabBarButton(text: "RAFFLE", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
        }
        .frame(maxWidth: .infinity)
    }
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct TabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        ZStack(alignment: .center) {
            if isSelected {
                Rectangle()
                    .fill(Color(red: 0.85, green: 0.25, blue: 0.47))
                    .frame(width:  isIpad ? 250: 170, height: isIpad ? 90: 50)//190
                    .cornerRadius(10, corners: [.topLeft, .topRight])
            }else{
                Rectangle()
                    .fill(Color(red: 0.85, green: 0.25, blue: 0.47))
                    .frame(width:  isIpad ? 250: 170, height: isIpad ? 90: 50)//190
                    .cornerRadius(10, corners: [.topLeft, .topRight])
                    .opacity(0)
            }
            Text(text)
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .font(.custom("MontserratRoman-SemiBold", size: UIDevice.current.userInterfaceIdiom == .pad ? 36 : 18))
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

extension Image {
    func data(url:URL) -> Self {
            if let data = try? Data(contentsOf: url) {
                return Image(uiImage: UIImage(data: data)!)
                    .resizable()
            }
    return self
    .resizable()
    }
}
