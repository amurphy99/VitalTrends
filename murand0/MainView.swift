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
            
            EventLogsView()
                .tabItem { Label("Logs", systemImage: "list.bullet.clipboard.fill") }
            
            PresetInfoView()
                .tabItem { Label("Presets", systemImage: "folder.fill") }
            
            
            UserEventsView()
                //.frame(alignment: .top)
                .tabItem { Label("Entries", systemImage: "iphone.radiowaves.left.and.right") }
            
            ContentView()
                .tabItem { Label("Log View", systemImage: "chart.xyaxis.line") }
            
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            //appearance.backgroundColor = UIColor(Color.orange.opacity(0.2))
            
            UITabBar.appearance().standardAppearance = appearance // Use this appearance when scrolling behind the TabView:
            UITabBar.appearance().scrollEdgeAppearance = appearance // Use this appearance when scrolled all the way up:
        }
        
    }
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
