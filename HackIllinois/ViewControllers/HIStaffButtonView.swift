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
    @State var events = [HIAPI.StaffEvent]()
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
                                .lineLimit(1) // Set lineLimit to 1
                                .foregroundColor(event.id == highlightedID ? .white : Color((\HIAppearance.profileBaseText).value))
                                .font(Font(HIAppearance.Font.QRCheckInFont ?? .systemFont(ofSize: 14)))
                                .padding(8)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white, lineWidth: 2)
                                        .background(event.id == highlightedID ? Color((\HIAppearance.profileBaseText).value) : Color.white)
                                        .cornerRadius(10)
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
        HIAPI.EventService.getStaffCheckInEvents(authToken: HIApplicationStateController.shared.user?.token ?? "")
            .onCompletion { result in
                do {
                    let (containedEvents, _) = try result.get()
                    DispatchQueue.main.async {
                        self.events = containedEvents.events
                        print(self.events)
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
