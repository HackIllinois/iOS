//
//  HIStaffButtonView.swift
//  HackIllinois
//
//  Created by Vincent Nguyen on 2/1/23.
//  Copyright © 2023 HackIllinois. All rights reserved.
//

import SwiftUI

struct HIStaffButtonView: View {
    var events: [CheckInEvent]
    var highlightedID = ""
    @ObservedObject var observable: HIStaffButtonViewObservable
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(events, id: \.eventID) { event in
                    Button(action: {
                        observable.selectedEventId = highlightedID
                        observable.onSelectEventId
                    }) {
                        Text(event.eventName)
                            .foregroundColor(event.eventID == highlightedID ? .white : Color((\HIAppearance.profileBaseText).value))
                            .font(Font(HIAppearance.Font.QRCheckInFont ?? .systemFont(ofSize: 14)))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2)
                                    .background(event.eventID == highlightedID ? Color((\HIAppearance.profileBaseText).value) : Color.white)
                            )
                    }
                }
            }
        }
    }
}

class HIStaffButtonViewObservable: ObservableObject {
    @Published var selectedEventId: String = ""
    var onSelectEventId: (()->Void)!
}

struct CheckInEvent {
    let eventName: String
    let eventID: String
}

