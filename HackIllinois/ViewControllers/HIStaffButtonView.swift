//
//  HIStaffButtonView.swift
//  HackIllinois
//
//  Created by Vincent Nguyen on 2/1/23.
//  Copyright © 2023 HackIllinois. All rights reserved.
//

import SwiftUI
import HIAPI

struct HIStaffButtonView: View {
    @State var events = [HIAPI.StaffEvent]()
    @State var highlightedID = ""
    @ObservedObject var observable: HIStaffButtonViewObservable
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(events, id: \.id) { event in
                    Button(action: {
                        highlightedID = event.id
                        observable.selectedEventId = event.id
                        observable.onSelectEventId
                    }) {
                        Text(event.name)
                            .foregroundColor(event.id == highlightedID ? .white : Color((\HIAppearance.profileBaseText).value))
                            .font(Font(HIAppearance.Font.QRCheckInFont ?? .systemFont(ofSize: 14)))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2)
                                    .background(event.id == highlightedID ? Color((\HIAppearance.profileBaseText).value) : Color.white)
                            )
                    }
                }
            }
        }
        .onAppear {
            getStaffEvents()
        }
    }

    func getStaffEvents() {
        HIAPI.EventService.getStaffCheckInEvents()
            .onCompletion { result in
                do {
                    let (containedEvents, _) = try result.get()
                    DispatchQueue.main.async {
                        self.events = containedEvents.events
                    }
                } catch {
                    print("An error has occurred \(error)")
                }
            }
            .authorize(with: HIApplicationStateController.shared.user)
            .launch()
    }
}

class HIStaffButtonViewObservable: ObservableObject {
    @Published var selectedEventId: String = ""
    var onSelectEventId: (() -> Void)!
}
