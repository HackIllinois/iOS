//
//  HIProfileCardView.swift
//  HackIllinois
//
//  Created by Vincent Nguyen on 11/30/22.
//  Copyright © 2022 HackIllinois. All rights reserved.
//

import SwiftUI

struct HIProfileCardView: View {
    var body: some View {
        
        GeometryReader { geometry in
            Rectangle()
                .size(width: geometry.size.width, height: geometry.size.height)
               }
        
    }
}

struct HIProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        HIProfileCardView()
    }
}
