//
//  NotificationsView.swift
//  murand0
//
//  Created by Andrew Murphy on 6/25/23.
//

import SwiftUI

struct NotificationsView: View {
    


    var body: some View {
        ZStack {
            //NOTIFICATIONS_GRADIENT.opacity(GRADIENT_OPACITY).ignoresSafeArea()
            gradientBackgrounds().notificationsGradient().opacity(GRADIENT_OPACITY).ignoresSafeArea()
            VStack {
            
                
                
                

                
                
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
