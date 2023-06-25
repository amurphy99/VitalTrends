//
//  CreateNewLogFromPreset.swift
//  murand0
//
//  Created by Andrew Murphy on 6/24/23.
//

import SwiftUI

struct CreateNewLogFromPresetsView: View {
    
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
    
    
    @State var new_date = Date()
    
    @State var selectedIndividualPresets: Set<IndividualPreset> = []
    @State var selectedGroupPresets: Set<IndividualPreset> = [] // not actually using atm
    
    @State var selectedPreset: GroupPreset?
    @State var selectedPresetEntries: [IndividualPreset] = []
    
    
    var body: some View {
        NavigationView {
            ZStack {
                gradient.opacity(GRADIENT_OPACITY).ignoresSafeArea()
                VStack {
                    // Picker and Date
                    // ======================================================
                    VStack {
                        Spacer().frame(height: 10)
                        Picker("Select Event Type", selection: $selectedType) {
                            Text("Individual").tag(0)
                            Text("Group"     ).tag(1)
                        }
                        .pickerStyle(.segmented)
                        
                        
                        HStack {
                            HStack {
                                Spacer()
                                Text("Select Date").fontWeight(.semibold)
                            }
                            DatePicker("", selection: $new_date, displayedComponents: [.date, .hourAndMinute])
                        }
                        
                        Divider()
                    }
                    .padding(.horizontal)
                    
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
                                                .foregroundColor(.black).font(.title3).fontWeight(.semibold).textCase(nil)
                                                .listRowInsets(SECTION_EDGE_INSETS),
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
                                                    Text("\(preset_event.name) (\(preset_event.entries.count))")
                                                        //.truncationMode(.tail).lineLimit(1)
                                                        .tag( GroupPreset?.some(preset_event) )
                                                }
          
                                            }
                                            .pickerStyle(MenuPickerStyle())
                                            .onChange(of: selectedPreset) { _ in
                                                if selectedPreset != nil { selectedPresetEntries = Array(selectedPreset!.entries) as! [IndividualPreset]
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
                                        if selectedPreset != nil { selectedPresetEntries = Array(selectedPreset!.entries) as! [IndividualPreset]
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
                            saveData()
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
        // check validity
        if (selectedIndividualPresets.count + selectedPresetEntries.count) < 1 { return }
        
        // from Individual
        for preset_entry in selectedIndividualPresets {
            let newEvent = UserEvent(context: viewContext)
            newEvent.timestamp = new_date
            newEvent.type      = preset_entry.type
            newEvent.name      = preset_entry.name
            newEvent.quantity  = preset_entry.quantity
            newEvent.units     = preset_entry.units
        }
        // from Group
        for preset_entry in selectedPresetEntries {
            let newEvent = UserEvent(context: viewContext)
            newEvent.timestamp = new_date
            newEvent.type      = preset_entry.type
            newEvent.name      = preset_entry.name
            newEvent.quantity  = preset_entry.quantity
            newEvent.units     = preset_entry.units
        }
        
        // save them all
        do { try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        // dismiss view
        isPresented = false
    }
    
    
    
    // was for the list of group entries, couldnt get it working to have two edit mode lists a the same time
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
                        Text("\(preset.name)")
                    }
                }
            }.navigationBarItems( leading: EditButton() )
            .environment(\.editMode, $editMode)
            .scrollContentBackground(.hidden)
            .frame(height: listHeight)
        }
    }
    
    
    
    
    
}



struct CreateNewLogFromPresetsView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewLogFromPresetsView(isPresented: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
