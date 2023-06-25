//
//  SinglePresetView.swift
//  murand0
//
//  Created by Andrew Murphy on 12/29/22.
//

import SwiftUI

struct SinglePresetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \IndividualPreset.name, ascending: true)], animation: .default)
    private var preset_entries: FetchedResults<IndividualPreset>

    @State var selectedPreset: IndividualPreset?
    @State var selectedPresetEntries: [IndividualPreset] = []
    
    // for single event
    @Binding    var new_date:      Date
    
    
    
    var body: some View {
        VStack {
            // Picker Section
            // ===================================================================
            HStack {
                Text("Select a Preset:").bold().frame(alignment: .leading)
                
                // Picker
                Picker("Multiple Preset Picker", selection: $selectedPreset) {
                    // None option
                    Text("None").tag(IndividualPreset?.none)
                    // Other options
                    ForEach(preset_entries, id: \.self) { preset_entry in
                        Text("\(preset_entry.name)").tag( IndividualPreset?.some(preset_entry) )
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: selectedPreset) { _ in
                    if selectedPreset != nil {
                        selectedPresetEntries = [selectedPreset] as! [IndividualPreset]
                    } else { selectedPresetEntries = [] }
                }
                Spacer()
            }

            // Selected Items
            // ===================================================================
            NavigationView {
                ScrollView {
                    LazyVStack {
                        List {
                            Section ( header: entry_header(),
                                      footer: Text("\(selectedPresetEntries.count) items")
                            ) {
                                ForEach(selectedPresetEntries) { preset_entry in entry_row(entry: preset_entry) }
                            }
                        }
                        .frame(height: UIScreen.main.bounds.height*0.13)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height*0.13)
            
            // Submit Button
            // ===================================================================
            Button {
                if selectedPresetEntries.count > 0 { save_single_preset() }
            } label: {
                Text("Save Entry").font(.title3).padding(.horizontal)
            }
            .buttonStyle(.borderedProminent)
            
            
            Spacer()
            
            
        // end of VStack
        }
        .padding(.horizontal)

    // end of body
    }
    

    

    
    // Function for saving
    // =========================================================
    func save_single_preset() {
        // create the new event
        // ---------------------
        let newEvent = UserEvent(context: viewContext)
        newEvent.timestamp = new_date
        newEvent.type      = selectedPresetEntries[0].type
        newEvent.name      = selectedPresetEntries[0].name
        newEvent.quantity  = selectedPresetEntries[0].quantity
        newEvent.units     = selectedPresetEntries[0].units
        
        // save it when done
        // ------------------
        do { try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        // clear selected entries
        // -----------------------
        selectedPresetEntries = []
    }
    
    
    
}

struct SinglePresetView_Previews: PreviewProvider {
    static var previews: some View {
        SinglePresetView( new_date: .constant(Date()) )
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
