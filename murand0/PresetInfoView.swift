//
//  PresetInfoView.swift
//  murand0
//
//  Created by Andrew Murphy on 6/22/23.
//

import SwiftUI

struct PresetInfoView: View {
    
    // CoreData
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var user_SinglePresets = [PresetEntry]()
    @State var user_GroupPresets  = [GroupPreset]()
    


    
    // background color
    let gradient = LinearGradient(colors: [.orange, .cyan],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
    
    
    
    var body: some View {
        ZStack {
            gradient
                .opacity(0.25)
                .ignoresSafeArea()
            VStack {
                
                
                // Navigation View with list of events
                // ======================================================
                NavigationView {
                    ZStack {
                        gradient // gradient background
                            .opacity(0.25)
                            .ignoresSafeArea()
                    
                        
                        // list of presets
                        ScrollView{
                            LazyVStack {
                                
                                List{
                                    // Single Presets
                                    Section {
                                        ForEach(user_SinglePresets, id: \.self) { preset in
                                            Text("\(preset.name ?? " ")")
                                        }
                                    }
                                    // Multiple Presets
                                    Section {
                                        ForEach(user_GroupPresets, id: \.self) { preset in
                                            Text("\(preset.name ?? " ")")
                                        }
                                    }

                                    
                                    
                                }
                                .scrollContentBackground(.hidden)
                                .frame(height: UIScreen.main.bounds.height)
                                
                                
                                    .toolbar {
                                        ToolbarItem(placement: .navigationBarLeading){
                                            Text("User Presets").font(.title).fontWeight(.semibold)
                                        }
                                    }
                            }
                        }
                        
                        
                    }
                }
                .onAppear {
                    let appearance = UINavigationBarAppearance()
                    appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                    //appearance.backgroundColor = UIColor(Color.orange.opacity(0.1))
                    
                    UINavigationBar.appearance().standardAppearance = appearance // Inline appearance (standard height appearance)
                    UINavigationBar.appearance().scrollEdgeAppearance = appearance // Large Title appearance
                }
            } // end parent VStack
        }
        .onAppear { load_data() }
    }
    
    // function to load in data for the page
    // ======================================================
    func load_data() {
        load_PresetEntries()
        load_GroupPresets()
    }
    func load_PresetEntries() {
        let request = PresetEntry.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            user_SinglePresets = try viewContext.fetch(request)
            print("Got \(user_SinglePresets.count) commits")
        } catch { print("Fetch failed") }
    }
    func load_GroupPresets() {
        let request = GroupPreset.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            user_GroupPresets = try viewContext.fetch(request)
            print("Got \(user_GroupPresets.count) commits")
        } catch { print("Fetch failed") }
    }
        
        
        
    
}

struct PresetInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PresetInfoView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
