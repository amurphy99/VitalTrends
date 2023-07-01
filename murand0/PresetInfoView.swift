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
    @State var dataConfig: modifyDataConfig = modifyDataConfig()
    @State private var showAnimation: Bool = false

    @State var showingCreateNewPreset = false
    
    var body: some View {
        NavigationView {
            ZStack {
                PRESETS_GRADIENT.opacity(GRADIENT_OPACITY).ignoresSafeArea()
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
                                        IndividualPresetInfoView(individualPreset: preset, dataConfig: $dataConfig)
                                            .navigationTitle(Text("\(preset.name)"))
                                    } label: {
                                        HStack {
                                            Text("\(preset.name)")
                                            Text("\(myNumberFormatter.string(for: preset.quantity)!) \(preset.units)")
                                                .fontWeight(.light)
                                                .foregroundColor(.gray)
                                        }
                                        .truncationMode(.tail).lineLimit(1)
                                    }
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
                                        GroupPresetInfoView(groupPreset: preset, dataConfig: $dataConfig)
                                            .navigationTitle(Text("\(preset.name)"))
                                    } label: {
                                        HStack {
                                            Text("\(preset.name)")
                                            Text("(\(preset.entries.count))")
                                                .fontWeight(.light)
                                                .foregroundColor(.gray)
                                        }
                                        .truncationMode(.tail).lineLimit(1)
                                    }
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
                    CreateNewPresetView(isPresented: $showingCreateNewPreset, dataConfig: $dataConfig)
                }
            }
        }
        .onAppear {
            user_SinglePresets = loadIndividualPresets(viewContext: viewContext)
            user_GroupPresets = loadGroupPresets(viewContext: viewContext)
            
            // only need this if previewing
            //UINavigationBar.appearance().standardAppearance   = navBarStyle()
            //UINavigationBar.appearance().scrollEdgeAppearance = navBarStyle()
            
        }
        .onChange(of: dataConfig) { _ in
            user_SinglePresets = loadIndividualPresets(viewContext: viewContext)
            user_GroupPresets = loadGroupPresets(viewContext: viewContext)
            showAnimation.toggle()
        }
        .animation(.easeIn, value: showAnimation)
    }
    
        
        
        
    
}

struct PresetInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PresetInfoView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
