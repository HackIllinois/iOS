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
    var body: some View {
        ForEach(events, id: \.eventID) { event in
           
            Button(action: {
                // sets the currentID
                // highlights that image
                   }) {
                       Text(event.eventName)
                          // .foregroundColor(event.eventID == highlightedID ? HIAppearan  : .white)
                           .font(Font(HIAppearance.Font.QRCheckInFont ?? .systemFont(ofSize: 14)))
                           .padding()
                           .background(
                            RoundedRectangle(cornerRadius: 10)
                               .stroke(Color.white, lineWidth: 2)
                               .background(event.eventID == highlightedID ? Color.white : Color.clear)
                           )
                   }
        }
        
    }
   
}

struct HIStaffButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HIStaffButtonView(events: [CheckInEvent(eventName: "event", eventID: "id")])
    }
}

struct CheckInEvent {
    let eventName: String
    let eventID: String
}

