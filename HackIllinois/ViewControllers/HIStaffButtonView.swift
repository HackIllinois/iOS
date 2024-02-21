//
//  HIStaffButtonView.swift
//  HackIllinois
//
//  Created by HackIllinois on 2/1/23.
//  Copyright © 2023 HackIllinois. All rights reserved.
//

import SwiftUI
import HIAPI

struct HIStaffButtonView: View {
    @State var events = [HIAPI.Event]()
    @State var highlightedID = ""
    @ObservedObject var observable: HIStaffButtonViewObservable
    
    let columns = [
        GridItem(.flexible(minimum: 0)),
        GridItem(.flexible(minimum: 0))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(events, id: \.id) { event in
                    Button(action: {
                        highlightedID = event.id
                        observable.selectedEventId = event.id
                    }) {
                        VStack {
                            Text(event.name)
                                .lineLimit(2) // Set lineLimit
                                .foregroundColor(event.id == highlightedID ? .white : Color((\HIAppearance.profileBaseText).value))
                                .font(Font(HIAppearance.Font.QRCheckInFont ?? .systemFont(ofSize: 14)))
                                .padding(5)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 2)
                                        .background(event.id == highlightedID ? Color((\HIAppearance.profileBaseText).value) : Color.white.opacity(0.50))
                                        .cornerRadius(20)
                                )
                        }
                    }
                }
            }
        }
        .onAppear {
            getStaffEvents()
        }
    }
    
    func getStaffEvents() {
        guard let user = HIApplicationStateController.shared.user else { return }
        HIAPI.EventService.getStaffCheckInEvents(authToken: user.token)
            .onCompletion { result in
                do {
                    let (containedEvents, _) = try result.get()
                    DispatchQueue.main.async {
                        self.events = containedEvents.events.filter { $0.displayOnStaffCheckIn == true }
                    }
                } catch {
                    print("An error has occurred \(error)")
                }
            }
            .launch()
    }
}

class HIStaffButtonViewObservable: ObservableObject {
    @Published var selectedEventId: String = ""
}
