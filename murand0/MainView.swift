//
//  MainView.swift
//  murand0
//
//  Created by Andrew Murphy on 6/20/23.
//

import SwiftUI

struct MainView: View {
    
    // view body
    // ==============================================================
    var body: some View {
        TabView {
            
            UserEventsView()
                //.frame(alignment: .top)
                .tabItem { Label("Device Status", systemImage: "iphone.radiowaves.left.and.right") }
            
            
            ContentView()
                .tabItem { Label("Log View", systemImage: "chart.xyaxis.line") }
            
            
        }
        
    }
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
