//
//  viewFormatHelpers.swift
//  murand0
//
//  Created by Andrew Murphy on 2/2/23.
//

import Foundation
import SwiftUI



let SECTION_EDGE_INSETS: EdgeInsets = EdgeInsets(top: 0, leading: 2, bottom: 2, trailing: 0)

// Gradients
// ===============================================================================
let GRADIENT_OPACITY: Double = 0.30 // original was 0.25
let EVENTS_GRADIENT         = LinearGradient(colors: [.orange, .green   ], startPoint: .topLeading, endPoint: .bottomTrailing)
let PRESETS_GRADIENT        = LinearGradient(colors: [.orange, .cyan    ], startPoint: .topLeading, endPoint: .bottomTrailing)
let NOTIFICATIONS_GRADIENT  = LinearGradient(colors: [.orange, .pink    ], startPoint: .topLeading, endPoint: .bottomTrailing)



class gradientBackgrounds {
    
    var startPoint: UnitPoint = UnitPoint(x: 0.5, y: 0.3)
    var endPoint:   UnitPoint = UnitPoint(x: 0.5, y: 1.0)
    
    func notificationsGradient() -> LinearGradient {
        
        return LinearGradient(colors: [.orange, .pink ], startPoint: startPoint, endPoint: endPoint)
        
    }
    
}

// Navigation Bar
// ===============================================================================

//UINavigationBar.appearance().standardAppearance   = navBarStyle() // Inline appearance (standard height appearance)
//UINavigationBar.appearance().scrollEdgeAppearance = navBarStyle() // Large Title appearance

func navBarStyle() -> UINavigationBarAppearance {
    let NAV_BAR = UINavigationBarAppearance()
    NAV_BAR.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
    //NAV_BAR.backgroundColor = UIColor(Color.orange.opacity(0.1))
    
    return NAV_BAR
}









extension View {
    func PDV_textfield(width: CGFloat)-> some View {
        self.frame(width: width * 0.7, alignment: .leading).padding(3).border(Color.gray, width: 1)
    }
    
    func newPresetTextField(_ width: CGFloat) -> some View {
        //self.fontWeight(.semibold).frame(width: width, alignment: .trailing)
        self.frame(width: width, alignment: .trailing)
    }
    
    func listSectionHeader() -> some View {
        return self
            .foregroundColor(.black)
            .font(.title3)
            //.fontWeight(.semibold)
            .textCase(nil)
    }
    
}




struct modifyDataConfig: Equatable {
    
    var wasChanged = false
    
    mutating func notifyChanges() {
        wasChanged.toggle()
    }
    
}



