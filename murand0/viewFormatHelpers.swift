//
//  viewFormatHelpers.swift
//  murand0
//
//  Created by Andrew Murphy on 2/2/23.
//

import Foundation
import SwiftUI


let GRADIENT_OPACITY: Double = 0.25


extension View {
    func PDV_textfield(width: CGFloat)-> some View {
        self.frame(width: width * 0.7, alignment: .leading).padding(3).border(Color.gray, width: 1)
    }
    
}

