//
//  SinglePresetView.swift
//  murand0
//
//  Created by Andrew Murphy on 12/29/22.
//

import SwiftUI

struct SinglePresetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \PresetEntry.name, ascending: true)], animation: .default)
    private var preset_entries: FetchedResults<PresetEntry>

    @State var selectedPreset: PresetEntry?
    @State var selectedPresetEntries: [PresetEntry] = []
    
    // for single event
    @Binding    var new_date:      Date
    
    
    
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 10) {
                
                // Title
                // ------
                //Text("Single Preset:").frame(width: geo.size.width * 0.90, alignment: .leading)
                Divider().frame(width: geo.size.width * 0.90)
                
                
                // Picker Section
                // ---------------
                VStack {
                    
                    Text("Select a Preset:").bold().frame(width: geo.size.width * 0.90, alignment: .leading)
                    
                    // Picker
                    Picker("Multiple Preset Picker", selection: $selectedPreset) {
                        // None option
                        Text("None").tag(PresetEntry?.none)
                        // Other options
                        ForEach(preset_entries, id: \.self) { preset_entry in
                            Text("\(preset_entry.name!)")
                                //.frame(width: geo.size.width * 0.90, alignment: .leading)
                                .tag( PresetEntry?.some(preset_entry) )
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedPreset) { _ in
                        if selectedPreset != nil {
                            selectedPresetEntries = [selectedPreset] as! [PresetEntry]
                        } else { selectedPresetEntries = [] }
                    }
                    
                }
                                
                
                // Selected Items
                // ---------------
                NavigationView { ScrollView { LazyVStack {
                    List {
                        Section ( header: entry_header() .frame(width: geo.size.width * 0.85),
                                  footer: Text("\(selectedPresetEntries.count) items").frame(width: geo.size.width * 0.85, alignment: .leading)
                        ) { ForEach(selectedPresetEntries) { preset_entry in entry_row(entry: preset_entry) } }
                    }.frame(width: geo.size.width, height: geo.size.height * 0.5)
                }}}.frame(height: geo.size.height * 0.5)
                
                Divider().frame(width: geo.size.width * 0.9)
                
                
                // Submit Button
                // --------------
                Button("Save Entry") {
                    if selectedPresetEntries.count > 0 {
                        // save entries
                        save_single_preset()
                        // clear form data
                        //selectedPresetEntries = []
                    }
                }
                .padding(5)
                .frame(width: geo.size.width * 0.9)
                .background(.cyan).foregroundColor(.white)
                
                
                Spacer()
                
                
            // end of VStack
            }
            .frame(width: geo.size.width)
        // end of geo
        }
    // end of body
    }
    
    
    // Function for saving
    // --------------------
    func save_single_preset() {
        // create the new event
        // ---------------------
        let newEvent = UserEvent(context: viewContext)
        newEvent.timestamp = new_date
        newEvent.type      = selectedPresetEntries[0].type!
        newEvent.name      = selectedPresetEntries[0].name!
        newEvent.quantity  = selectedPresetEntries[0].quantity
        newEvent.units     = selectedPresetEntries[0].units!
        
        // save it when done
        // ------------------
        do { try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
    
    
    
}

struct SinglePresetView_Previews: PreviewProvider {
    static var previews: some View {
        SinglePresetView( new_date: .constant(Date()) )
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
