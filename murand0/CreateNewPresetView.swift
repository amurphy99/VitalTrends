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
    
    
    let gradient = LinearGradient(colors: [.orange, .cyan],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)

    private let InfoLabelWidth: CGFloat = 70
    private let StockLabelWidth: CGFloat = 130
    
    @State var selectedType: Int = 0
    @State var editMode = EditMode.active
    @State var selectedPresets: Set<IndividualPreset> = []
    
    
    @State var name: String = ""
    @State var type: String = ""
    @State var quantity: Float = 0
    @State var units: String = ""
    @State var numberOfUnits: Int = 0
    @State var takenPerWeek: Float = 0
    
    
    var body: some View {
        NavigationView {
            ZStack {
                gradient.opacity(0.25).ignoresSafeArea()
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
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    
                    
                    // Forms
                    // ======================================================
                    VStack(alignment: .center) {
                        if selectedType == 0 {
                            // Individual
                            Form {
                                Section ( header:
                                            Text("Edit Preset Info")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .textCase(nil)
                                ) {
                                    HStack {
                                        Text("Type").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                        TextField(text: $type) { Text("Type") }
                                    }
                                    .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                    HStack {
                                        Text("Quantity").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                        TextField(value: $quantity, format: .number) { Text("Quantity") }
                                    }
                                    .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                    HStack {
                                        Text("Units").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                        TextField(text: $units) { Text("Units") }
                                    }
                                    .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                }
                                
                                Section (header: Text("Optional")) {
                                    HStack {
                                        Text("Current Stock").fontWeight(.semibold).frame(width: StockLabelWidth, alignment: .trailing)
                                        TextField(value: $numberOfUnits, format: .number) { Text("Current Stock") }
                                    }
                                    .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                    HStack {
                                        Text("Taken Per Week").fontWeight(.semibold).frame(width: StockLabelWidth, alignment: .trailing)
                                        TextField(value: $takenPerWeek, format: .number) { Text("Taken Per Week") }
                                    }
                                    .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                    
                                    HStack {
                                        Text("Days Left").fontWeight(.semibold).frame(width: StockLabelWidth, alignment: .trailing)
                                        if takenPerWeek > 0 { Text("\( Int((Float(numberOfUnits) / takenPerWeek)*7) )") }
                                        else                { Text("--")                                                }
                                    }
                                    .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                }
                            }
                            .frame(height: UIScreen.main.bounds.height*0.46)
                            .textFieldStyle(.roundedBorder)
                            .scrollContentBackground(.hidden)
                        }
                        else if selectedType == 1 {
                            // Group
                            VStack {
                                ScrollView {
                                    LazyVStack {
                                        List(selection: $selectedPresets) {
                                            Section (
                                                header: Text("Select presets to include:")
                                                    .foregroundColor(.black)
                                                    .font(.title3)
                                                    .fontWeight(.semibold)
                                                    .textCase(nil),
                                                footer: Text("\(userSinglePresets.count) items, \(selectedPresets.count) selected")
                                            ){
                                                ForEach(userSinglePresets, id: \.self) { preset in
                                                    Text("\(preset.name) (\(myNumberFormatter.string(for: preset.quantity)!) \(preset.units))")
                                                }
                                            }
                                        }
                                        .environment(\.editMode, $editMode)
                                        .scrollContentBackground(.hidden)
                                        .frame(height: UIScreen.main.bounds.height*0.46)
                                    }
                                }
                                .frame(height: UIScreen.main.bounds.height*0.46)
                            }
                        }
                    }
                    Divider().padding(.horizontal)
                    
                    
                    // Submit Button
                    // ======================================================
                    Button {
                        formSubmitted()
                    } label: {
                        if selectedType == 0 {
                            Text("Create New Individual Preset").font(.title3).padding(.horizontal)
                                .frame(width: UIScreen.main.bounds.width*0.75)
                        }
                        else if selectedType == 1 {
                            Text("Create New Group Preset").font(.title3).padding(.horizontal)
                                .frame(width: UIScreen.main.bounds.width*0.75)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    
                    Spacer()
                } // end main VStack

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){ Text("Create New Preset").font(.title).fontWeight(.semibold) }
                ToolbarItem(placement: .confirmationAction)  { Button("Cancel") { isPresented = false } }
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
    } // end main body
    
    
    
    // functions to load in data for the page
    // ======================================================
    private func loadData() {
        loadSinglePresets()
    }
    private func loadSinglePresets() {
        let request = IndividualPreset.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            userSinglePresets = try viewContext.fetch(request)
            print("Got \(userSinglePresets.count) commits")
        } catch { print("Fetch failed") }
    }
    
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
        //newInidividualPreset.numberOfUnits = numberOfUnits
        //newInidividualPreset.takenPerWeek  = takenPerWeek
        
        do { try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
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
        CreateNewPresetView(isPresented: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
