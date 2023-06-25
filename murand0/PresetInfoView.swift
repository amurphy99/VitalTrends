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
    
    @State var user_SinglePresets = [IndividualPreset]()
    @State var user_GroupPresets  = [GroupPreset]()
    

    // background color
    let gradient = LinearGradient(colors: [.orange, .cyan],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    @State var showingCreateNewPreset = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                gradient.opacity(GRADIENT_OPACITY).ignoresSafeArea()
            
                // list of presets
                ScrollView{
                    LazyVStack {
                        List{
                            // Single Presets
                            // ======================================================
                            Section (
                                header: Text("Individual Presets"),
                                footer: Text("\(user_SinglePresets.count) items")
                            ) {
                                ForEach(user_SinglePresets, id: \.self) { preset in
                                    NavigationLink {
                                        IndividualPresetInfoView(individualPreset: preset)
                                            .navigationTitle(Text("\(preset.name)"))
                                    } label: { Text("\(preset.name)").truncationMode(.tail).lineLimit(1) }
                                }
                            }
                            // Multiple Presets
                            // ======================================================
                            Section (
                                header: Text("Group Presets"),
                                footer: Text("\(user_GroupPresets.count) items")
                            ) {
                                ForEach(user_GroupPresets, id: \.self) { preset in
                                    NavigationLink {
                                        GroupPresetInfoView(groupPreset: preset)
                                            .navigationTitle(Text("\(preset.name)"))
                                    } label: { Text("\(preset.name)").truncationMode(.tail).lineLimit(1) }
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .frame(height: UIScreen.main.bounds.height)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading){
                                Text("User Presets").font(.title).fontWeight(.semibold)
                            }
                            ToolbarItem(placement: .navigationBarTrailing){
                                Button(action: { showingCreateNewPreset = true }) { Label("Add Item", systemImage: "plus") }
                            }
                        }
                    }
                } // end ScrollView
                .sheet(isPresented: $showingCreateNewPreset) {
                    CreateNewPresetView(isPresented: $showingCreateNewPreset)
                }
            }
        }
        .onAppear {
            load_data()
            
            let appearance = UINavigationBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            //appearance.backgroundColor = UIColor(Color.orange.opacity(0.1))
            
            UINavigationBar.appearance().standardAppearance = appearance // Inline appearance (standard height appearance)
            UINavigationBar.appearance().scrollEdgeAppearance = appearance // Large Title appearance
        }
 
    }
    
    // functions to load in data for the page
    // ======================================================
    private func load_data() {
        load_PresetEntries()
        load_GroupPresets()
    }
    private func load_PresetEntries() {
        let request = IndividualPreset.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            user_SinglePresets = try viewContext.fetch(request)
            print("Got \(user_SinglePresets.count) commits")
        } catch { print("Fetch failed") }
    }
    private func load_GroupPresets() {
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
