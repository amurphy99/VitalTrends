//
//  NotificationsView.swift
//  murand0
//
//  Created by Andrew Murphy on 6/25/23.
//

import SwiftUI

struct NotificationsView: View {
    
    @State var showingCreateNewNotification: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                //NOTIFICATIONS_GRADIENT.opacity(GRADIENT_OPACITY).ignoresSafeArea()
                gradientBackgrounds().notificationsGradient().opacity(GRADIENT_OPACITY).ignoresSafeArea()
                ScrollView {
                    LazyVStack {
                        List {
                            
                            
                            
                            
                            
                            
                            
                        }
                        //.scrollContentBackground(.hidden)
                        .frame(height: UIScreen.main.bounds.height)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading){
                                Text("Notifications").font(.title).fontWeight(.semibold)
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: { showingCreateNewNotification = true }) { Label("Add Item", systemImage: "plus") }
                            }
                        }
                    }
                }
            } // end of parent ZStack
        } // end of NavigationView
        .onAppear {
 
            // only need this if previewing
            //UINavigationBar.appearance().standardAppearance   = navBarStyle()
            //UINavigationBar.appearance().scrollEdgeAppearance = navBarStyle()
        }
    } // end of View body
    
}



struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
