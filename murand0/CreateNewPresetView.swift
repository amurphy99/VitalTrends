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
    private let InfoLabelWidth:     CGFloat = 70
    private let StockLabelWidth:    CGFloat = 130
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
    @State var numberOfUnits: Int = 0
    @State var perWeek: Float = 0
    @State var notifyWhenLow: Bool = false
    @State var notifyBelow: Int = 0
    // Individual Triggered Reminder
    
    
    
    
 
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
                        Text("New Preset Name:").fontWeight(.semibold)
                        TextField(text: $name) { Text("Name") }
                        Divider().padding(.top, 10)
                    }
                    .textFieldStyle(.roundedBorder).disableAutocorrection(true).autocapitalization(.none)
                    .padding(.horizontal)
                    
                    
                    // Forms
                    // ======================================================
                    VStack(alignment: .center) {
                        if selectedType == 0 {
                            // Individual
                            // ================================================================================
                            Form {
                                // Basic Info
                                Section ( header:
                                            Text("Preset Info")
                                    .foregroundColor(.black).font(.title3).fontWeight(.semibold).textCase(nil)
                                    .listRowInsets(SECTION_EDGE_INSETS)
                                ) {
                                    HStack {
                                        Text("Type").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                        TextField(text: $type) { Text("Type") }
                                    }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                    
                                    HStack {
                                        Text("Quantity").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                        TextField(value: $quantity, format: .number) { Text("Quantity") }
                                    }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                    
                                    HStack {
                                        Text("Units").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                        TextField(text: $units) { Text("Units") }
                                    }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                }
                                // Stock Info
                                Section (header: HStack {
                                    Text("Stock Info")
                                        .foregroundColor(.black).font(.title3).fontWeight(.semibold).textCase(nil)
                                    Text("(optional)").textCase(nil)
                                }.listRowInsets(SECTION_EDGE_INSETS)
                                ) {
                                    HStack {
                                        Text("Current Stock").fontWeight(.semibold).frame(width: StockLabelWidth, alignment: .trailing)
                                        TextField(value: $numberOfUnits, format: .number) { Text("Current Stock") }
                                    }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                    
                                    HStack {
                                        Text("Taken Per Week").fontWeight(.semibold).frame(width: StockLabelWidth, alignment: .trailing)
                                        TextField(value: $perWeek, format: .number) { Text("Taken Per Week") }
                                    }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                    
                                    HStack {
                                        Text("Days Left").fontWeight(.semibold).frame(width: StockLabelWidth, alignment: .trailing)
                                        if perWeek > 0 { Text("\( Int((Float(numberOfUnits) / perWeek)*7) )") }
                                        else           { Text("--")                                           }
                                    }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                    
                                    
                                    
                                }
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
                                                header: Text("Select presets to include:")
                                                    .foregroundColor(.black)
                                                    .font(.title3).fontWeight(.semibold).textCase(nil),
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
