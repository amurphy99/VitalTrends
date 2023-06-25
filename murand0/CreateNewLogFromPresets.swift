//
//  CreateNewLogFromPreset.swift
//  murand0
//
//  Created by Andrew Murphy on 6/24/23.
//

import SwiftUI

struct CreateNewLogFromPresets: View {
    
    // CoreData
    @Environment(\.managedObjectContext) private var viewContext
    @State var userIndividualPresets = [IndividualPreset]()
    @State var userGroupPresets = [GroupPreset]()
    
    
    @Binding var isPresented: Bool
    
    let gradient = LinearGradient(colors: [.orange, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
    private let listHeight: CGFloat = UIScreen.main.bounds.height*0.42
    
    @State var selectedType: Int = 0
    @State var editMode = EditMode.active
    
    @State var selectedIndividualPresets: Set<IndividualPreset> = []
    @State var selectedGroupPresets: Set<IndividualPreset> = [] // not actually using atm
    @State var selectedPreset: GroupPreset?
    @State var selectedPresetEntries: [IndividualPreset] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                gradient.opacity(0.25).ignoresSafeArea()
                VStack {
                    // Picker
                    // ======================================================
                    Spacer().frame(height: 10)
                    Picker("Select Event Type", selection: $selectedType) {
                        Text("Individual").tag(0)
                        Text("Group"     ).tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    Divider().padding(.horizontal)
                    
                    // Forms
                    // ======================================================
                    VStack {
                        ScrollView {
                            LazyVStack {
                                // Individual
                                // ------------------------------
                                if selectedType == 0 {
                                    List(selection: $selectedIndividualPresets) {
                                        Section (
                                            header: Text("Select presets to include:")
                                                .foregroundColor(.black).font(.title3).fontWeight(.semibold).textCase(nil),
                                            footer:
                                                Text("\(userIndividualPresets.count) items, \(selectedIndividualPresets.count) selected")
                                        ){
                                            ForEach(userIndividualPresets, id: \.self) { preset in
                                                Text("\(preset.name) (\(myNumberFormatter.string(for: preset.quantity)!) \(preset.units))")
                                            }
                                        }
                                    }
                                    .environment(\.editMode, $editMode)
                                    .scrollContentBackground(.hidden)
                                    .frame(height: listHeight)
                                }
                                
                                // Group
                                // ------------------------------
                                else if selectedType == 1 {
                                    //test()
                                    VStack {
                                        HStack {
                                            Text("Select a preset:").font(.title3).fontWeight(.semibold)
                                            
                                            // Picker
                                            Picker("Multiple Preset Picker", selection: $selectedPreset) {
                                                Text("None").tag(GroupPreset?.none) // None option
                                                // Other options
                                                ForEach(userGroupPresets, id: \.self) { preset_event in
                                                    Text("\(preset_event.name!) (\(preset_event.entries!.count))")
                                                        .tag( GroupPreset?.some(preset_event) )
                                                }
          
                                            }
                                            .pickerStyle(MenuPickerStyle())
                                            .onChange(of: selectedPreset) { _ in
                                                if selectedPreset != nil { selectedPresetEntries = selectedPreset!.entries!.allObjects as! [IndividualPreset]
                                                } else { selectedPresetEntries = [] }
                                            }
                                            Spacer()
                                        }
                                        .padding(.horizontal)
                                        
                                        // Selected Entries List
                                        // ----------------------
                                        List {
                                            Section (
                                                header: Text("Included Data"),
                                                footer: Text("\(selectedPresetEntries.count) items selected")
                                            ) {
                                                ForEach(selectedPresetEntries) { preset in
                                                    Text("\(preset.name) (\(myNumberFormatter.string(for: preset.quantity)!) \(preset.units))")
                                                }
                                            }
                                        }
                                        .scrollContentBackground(.hidden)
                                        .frame(height: listHeight)
                                    }
                                    .onChange(of: selectedPreset) { _ in
                                        if selectedPreset != nil { selectedPresetEntries = selectedPreset!.entries!.allObjects as! [IndividualPreset]
                                        } else { selectedPresetEntries = [] }
                                    }
                                }
                            }
                        }
                        .frame(height: listHeight)
                    }
                    Divider().padding(.horizontal)
                    
                    
                    // Save Button
                    // ======================================================
                    VStack {
                        Text("\(selectedIndividualPresets.count + selectedPresetEntries.count) total items selected")
                            .fontWeight(.light)
                            .foregroundColor(.gray)
                        
                        Button {
                            
                        } label: { Text("Save New Entry").font(.title3).padding(.horizontal) }
                        .buttonStyle(.borderedProminent)
                    }
                    

                    Spacer()
                } // end VStack
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){ Text("Add New Entry").font(.title).fontWeight(.semibold) }
                    ToolbarItem(placement: .confirmationAction)  { Button("Cancel") { isPresented = false } }
                }
            }
        } // end Navigation View
        .onAppear {
            loadData()
            
            let appearance = UINavigationBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            //appearance.backgroundColor = UIColor(Color.orange.opacity(0.1))
            
            UINavigationBar.appearance().standardAppearance = appearance // Inline appearance (standard height appearance)
            UINavigationBar.appearance().scrollEdgeAppearance = appearance // Large Title appearance
        }
    } // end View body
    
    
    // functions to load in data for the page
    // ======================================================
    private func loadData() {
        loadPresetEntries()
        loadGroupPresets()
    }
    private func loadPresetEntries() {
        let request = IndividualPreset.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            userIndividualPresets = try viewContext.fetch(request)
            print("Got \(userIndividualPresets.count) commits")
        } catch { print("Fetch failed") }
    }
    private func loadGroupPresets() {
        let request = GroupPreset.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            userGroupPresets = try viewContext.fetch(request)
            print("Got \(userGroupPresets.count) commits")
        } catch { print("Fetch failed") }
    }
    
    
    // functions to load in data for the page
    // ======================================================
    private func saveData() {
        
    }
    
    
    
    
    private func test() -> some View {
        return NavigationView {
            List(selection: $selectedGroupPresets) {
                Section (
                    header: Text("Select presets to include:")
                        .foregroundColor(.black)
                        .font(.title3).fontWeight(.semibold).textCase(nil),
                    footer:
                        Text("\(userGroupPresets.count) items, \(selectedGroupPresets.count) selected")
                ){
                    ForEach(userGroupPresets, id: \.self) { preset in
                        Text("\(preset.name ?? "")")
                    }
                }
            }.navigationBarItems( leading: EditButton() )
            .environment(\.editMode, $editMode)
            .scrollContentBackground(.hidden)
            .frame(height: listHeight)
        }
    }
    
    
    
    
    
}



struct CreateNewLogFromPresets_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewLogFromPresets(isPresented: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
