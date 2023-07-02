//
//  CreateNewPresetView.swift
//  murand0
//
//  Created by Andrew Murphy on 6/24/23.
//

import SwiftUI

struct CreateNewPresetView: View {
    
    // CoreData
    @Environment(\.managedObjectContext) private var viewContext
    @State var userSinglePresets = [IndividualPreset]()
    
    @Binding var isPresented: Bool
    @Binding var dataConfig: modifyDataConfig
    

    // Styling variables
    private let listHeight:         CGFloat = UIScreen.main.bounds.height*0.60
    private let buttonWidth:        CGFloat = UIScreen.main.bounds.width*0.75
    
    // Page Control Variables
    // -----------------------
    @State var selectedType: Int = 0
    @State var name: String = ""
    
    // Group
    @State var editMode = EditMode.active
    @State var selectedPresets: Set<IndividualPreset> = []
    
    // Individual Info
    @State var type: String = ""
    @State var quantity: Float = 0
    @State var units: String = ""
    
    // Individual Stock
    @State var numberOfUnits: Int16 = 0
    @State var perWeek: Float = 0
    @State var notifyWhenLow: Bool = false
    @State var notifyBelow: Int = 0
    // Individual Triggered Reminder
    @State var triggerNotification: Bool = false
    @State var triggerMessage: String = ""
    @State var triggerHours: Int = 0
    @State var triggerMinutes: Int = 0
    
    
 
    var body: some View {
        NavigationView {
            ZStack {
                PRESETS_GRADIENT.opacity(GRADIENT_OPACITY).ignoresSafeArea()
                VStack {
                    // Picker and Name
                    // ======================================================
                    Spacer().frame(height: 10)
                    Picker("Select Event Type", selection: $selectedType) {
                        Text("Individual").tag(0)
                        Text("Group"     ).tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    VStack (alignment: .leading, spacing: 5) {
                        Text("New Preset Name:").listSectionHeader()
                        TextField(text: $name) { Text("Name") }
                        Divider().padding(.top, 10)
                    }
                    .textFieldStyle(.roundedBorder).disableAutocorrection(true).autocapitalization(.none)
                    .padding(.horizontal)
                    
                    
                    // Forms
                    VStack(alignment: .center) {
                        if selectedType == 0 {
                            // Individual
                            // ================================================================================
                            Form {
                                // Basic Info
                                // ------------------------------------------------------
                                presetMainInfoSection(
                                    ($type, $quantity, $units),
                                    header: Text("Preset Info").listSectionHeader().listRowInsets(SECTION_EDGE_INSETS)
                                )
                                
                                // Stock Info
                                // ------------------------------------------------------
                                presetStockSection(
                                    ($numberOfUnits, $perWeek, $notifyWhenLow, $notifyBelow),
                                    header:
                                        HStack {
                                            Text("Stock Info").listSectionHeader()
                                            Text("(optional)").textCase(nil)
                                        }.listRowInsets(SECTION_EDGE_INSETS),
                                    hasFooter: true
                                )
                                
                                // Trigger Notification Info
                                // ------------------------------------------------------
                                presetTriggerNotificationSection(
                                    ($triggerNotification, $triggerMessage, $triggerHours, $triggerMinutes),
                                    header:
                                        HStack {
                                            Text("Notification Info").listSectionHeader()
                                            Text("(optional)").textCase(nil)
                                        }.listRowInsets(SECTION_EDGE_INSETS),
                                    hasFooter: true
                                )

                            }
                            .frame(height: listHeight)
                            .textFieldStyle(.roundedBorder).disableAutocorrection(true).autocapitalization(.none)
                            .scrollContentBackground(.hidden)
                        }
                        // Group
                        // ================================================================================
                        else if selectedType == 1 {
                            VStack {
                                ScrollView {
                                    LazyVStack {
                                        List(selection: $selectedPresets) {
                                            Section (
                                                header: Text("Select presets to include:").listSectionHeader().listRowInsets(SECTION_EDGE_INSETS),
                                                footer: Text("\(userSinglePresets.count) items, \(selectedPresets.count) selected")
                                            ){
                                                ForEach(userSinglePresets, id: \.self) { preset in
                                                    Text("\(preset.name) (\(myNumberFormatter.string(for: preset.quantity)!) \(preset.units))")
                                                }
                                            }
                                        }
                                        .environment(\.editMode, $editMode)
                                        .scrollContentBackground(.hidden)
                                        .frame(height: listHeight)
                                    }
                                }
                                .frame(height: listHeight)
                            }
                        }
                    }
                    Divider().padding(.horizontal)
                    
                    
                    // Submit Button
                    // ======================================================
                    Button { formSubmitted()
                    } label: {
                        if selectedType == 0 {
                            Text("Create New Individual Preset").font(.title3).padding(.horizontal).frame(width: buttonWidth)
                        }
                        else if selectedType == 1 {
                            Text("Create New Group Preset").font(.title3).padding(.horizontal).frame(width: buttonWidth)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    
                    Spacer()
                } // end main VStack

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Text("Create New Preset").font(.title).fontWeight(.semibold) }
                ToolbarItem(placement: .confirmationAction)   { Button("Cancel") { isPresented = false } }
            }
        } // end Navigation View
        .onAppear {
            userSinglePresets = loadIndividualPresets(viewContext: viewContext)
            
            // only need this if previewing
            UINavigationBar.appearance().standardAppearance   = navBarStyle()
            UINavigationBar.appearance().scrollEdgeAppearance = navBarStyle()
        }
    } // end main body
    
    
    
    // function to save newly created presets
    // ======================================================
    private func formSubmitted() {
        if      selectedType == 0 { isPresented = validateIndividualForm()  }
        else if selectedType == 1 { isPresented = validateGroupForm()       }
    }
    
    // Invidividual
    private func validateIndividualForm() -> Bool {
        if name.count > 1 { saveNewIndividualPreset(); return false }
        return true
    }
    private func saveNewIndividualPreset() {
        let newInidividualPreset = IndividualPreset(context: viewContext)
        newInidividualPreset.type     = type
        newInidividualPreset.name     = name
        newInidividualPreset.quantity = quantity
        newInidividualPreset.units    = units
        newInidividualPreset.numberOfUnits  = Int16(numberOfUnits)
        newInidividualPreset.perWeek        = perWeek
        
        do { try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        dataConfig.notifyChanges()
    }
    
    private func createNewIndividualPreset() {
        // create args
        let presetInfo = (name, type, quantity, units)
        let triggerDelaySeconds = ((triggerHours*60)+triggerMinutes)*60
        let notificationsInfo = (notifyWhenLow, triggerNotification, triggerMessage, perWeek, triggerDelaySeconds, notifyBelow, numberOfUnits)
        
        // create new preset using info
        createIndividualPreset(presetInfo, notificationsInfo, viewContext)
        
        // for other views
        dataConfig.notifyChanges()
    }
    
    
    
    
    
    // Group
    private func validateGroupForm() -> Bool {
        if selectedPresets.count > 1 && name.count > 1 { saveNewGroupPreset(); return false }
        return true
    }
    private func saveNewGroupPreset() {
        let new_GroupPreset = GroupPreset(context: viewContext)
        
        new_GroupPreset.name = name
        for preset in selectedPresets { new_GroupPreset.addToEntries(preset) } // included single presets
        
        // save new preset
        do { try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    

    
    
    
    
}

struct CreateNewPresetView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var dataConfig: modifyDataConfig = modifyDataConfig()
        
        CreateNewPresetView(isPresented: .constant(true), dataConfig: $dataConfig)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
