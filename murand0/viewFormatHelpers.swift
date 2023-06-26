//
//  viewFormatHelpers.swift
//  murand0
//
//  Created by Andrew Murphy on 2/2/23.
//

import Foundation
import SwiftUI



let SECTION_EDGE_INSETS: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

let GRADIENT_OPACITY: Double = 0.30 // original was 0.25
let EVENTS_GRADIENT = LinearGradient(colors: [.orange, .green],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing)
let PRESETS_GRADIENT = LinearGradient(colors: [.orange, .cyan],
                                      startPoint: .topLeading,
                                      endPoint: .bottomTrailing)




extension View {
    func PDV_textfield(width: CGFloat)-> some View {
        self.frame(width: width * 0.7, alignment: .leading).padding(3).border(Color.gray, width: 1)
    }
    
}



struct modifyDataConfig: Equatable {
    
    var wasChanged = false
    
    mutating func notifyChanges() {
        wasChanged.toggle()
    }
    
}



