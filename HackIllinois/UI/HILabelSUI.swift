//
//  HILabelSUI.swift
//  HackIllinois
//
//  Created by Vincent Nguyen on 11/9/22.
//  Copyright © 2022 HackIllinois. All rights reserved.
//

import SwiftUI

struct HILabelSUI: View {
    // MARK: - Properties
    let labelText: String
    let textHIColor: HIColor
    let font: UIFont?
    let backgroundHIColor: HIColor
    var textAlignment: TextAlignment = .leading
    var borderWidth: CGFloat = 0
    var borderColor: Color = .clear
    // MARK: - Init
    init(labelText: String, style: Style) {
        self.labelText = labelText
        switch style {
            
        case .location:
            self.textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.contentText
            
        case .event:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.eventTitle
            
        case .eventTime:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.eventTime
            
        case .eventType:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.eventCategoryText
            
        case .sponsor:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.sponsorText
            
        case .detailTitle:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.detailTitle
            
        case .detailSubtitle:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.detailSubtitle
            
        case .detailText:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.detailText
            
        case .project:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.contentTitle
            
        case .viewTitle:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.viewTitle
            
        case .subtitle:
            textHIColor = \.accent
            backgroundHIColor = \.clear
            font = HIAppearance.Font.contentSubtitle
            
        case .description:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.descriptionText
            
        case .cellDescription:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.eventDetails
            
        case .loginHeader:
            textHIColor = \.loginTitleBackground
            backgroundHIColor = \.clear
            font = HIAppearance.Font.loginTitle
            
        case .welcomeTitle:
            textHIColor = \.loginSelectionText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.loginTitle
            
        case .backgroundTitle:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.navigationSubtitle
            
        case .loginSelection:
            textHIColor = \.loginSelectionText
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.loginSelection
//            borderWidth = 2.0
//            borderColor = Color((\HIAppearance.loginSelectionText).value.cgColor)
            
        case .profileName: // Used to display the profile owner's name
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.profileName
            
        case .profileSubtitle: // Used to display profile subtitle, "points", and whatever that says "time zone"
            backgroundHIColor = \.clear
            textHIColor = \.baseText
            textAlignment = .center
            font = HIAppearance.Font.profileSubtitle
            
        case .profileNumberFigure: // Used to display number of points and time (?)
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.profileNumberFigure
            
        case .profileTier: // Used to display "short description"
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            textAlignment = .leading
            font = HIAppearance.Font.profileTier
            
        case .profileUsername: // Used to display Discord username, etc.
            textHIColor = \.whiteTagFont
            backgroundHIColor = \.clear
            textAlignment = .leading
            font = HIAppearance.Font.profileUsername
            
        case .profileInterests:
            textHIColor = \.whiteTagFont
            backgroundHIColor = \.clear
            textAlignment = .center
            font = HIAppearance.Font.profileInterests
            
        case .navigationInfo:
            textHIColor = \.titleText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.navigationInfoText
            textAlignment = .leading
            
        case .countdown:
            textHIColor = \.titleText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.countdownText
            
        case .pointsText:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.eventButtonText
            textAlignment = .center
            
        case .error:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.detailSubtitle
            textAlignment = .center
            
        case .codeError:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.detailSubtitle
            textAlignment = .center

        case .onboardingDescription:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.onboardingDescription
            textAlignment = .center
        
        case .onboardingTitle:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.onboardingTitle
            textAlignment = .center
            
        case .clock:
            textHIColor = \.baseText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.clockText
            textAlignment = .center
            
            // Leaderboard label fonts
        case .leaderboardRank:
            textHIColor = \.leaderboardText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.leaderboardRank
            //layer.shadowOffset = CGSize(width: 2, height: 2)
            //layer.shadowRadius = 2.0
            //layer.shadowOpacity = 0.25
        case .leaderboardName:
            textHIColor = \.leaderboardText
            backgroundHIColor = \.clear
            font = HIAppearance.Font.leaderboardPoints
        case .leaderboardPoints:
            textHIColor = \.leaderboardText
            backgroundHIColor = \.pointsBackground
            font = HIAppearance.Font.leaderboardPoints
        }
        
    }
    var body: some View {
        Text(labelText)
            .foregroundColor(Color(textHIColor.value))
            .background(Color(backgroundHIColor.value))
            .font(Font(font!))
            .multilineTextAlignment(textAlignment)
            .border(borderColor, width: borderWidth)
    }
    
    // MARK: - Types
    enum Style {
        case location
        case event
        case eventTime
        case eventType
        case sponsor
        case project
        case viewTitle
        case detailTitle
        case subtitle
        case description
        case cellDescription
        case loginHeader
        case loginSelection
        case welcomeTitle
        case backgroundTitle
        case detailSubtitle
        case detailText
        case profileName
        case profileSubtitle
        case profileNumberFigure
        case profileTier
        case profileUsername
        case profileInterests
        case navigationInfo
        case countdown
        case pointsText
        case error
        case codeError
        case onboardingDescription
        case onboardingTitle
        case clock
        case leaderboardRank
        case leaderboardName
        case leaderboardPoints
    }
}

struct HILabelSUI_Previews: PreviewProvider {
    static var previews: some View {
        HILabelSUI(labelText: "HELLO", style: .loginSelection)
    }
}
