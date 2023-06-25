//
//  MultiplePresetView.swift
//  murand0
//
//  Created by Andrew Murphy on 12/30/22.
//

import SwiftUI

struct MultiplePresetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \GroupPreset.name, ascending: true)], animation: .default)
    var preset_events: FetchedResults<GroupPreset>

    @State var selectedPreset: GroupPreset?
    @State var selectedPresetEntries: [IndividualPreset] = []
    
    @Binding var new_date: Date
    
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 10) {
                
                // Title
                // ------
                Divider().frame(width: geo.size.width * 0.90)
                
                
                // Picker Section
                // ---------------
                VStack {
                    Text("Select a Preset:").bold().frame(width: geo.size.width * 0.90, alignment: .leading)
                    
                    // Picker
                    Picker("Multiple Preset Picker", selection: $selectedPreset) {
                        Text("None").tag(GroupPreset?.none) // None option
                        // Other options
                        ForEach(preset_events, id: \.self) { preset_event in
                            Text("\(preset_event.name) (\(preset_event.entries.count))")
                                //.frame(width: geo.size.width * 0.90, alignment: .leading)
                                .tag( GroupPreset?.some(preset_event) )
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedPreset) { _ in
                        if selectedPreset != nil { selectedPresetEntries = Array(selectedPreset!.entries) as! [IndividualPreset]
                        } else { selectedPresetEntries = [] }
                    }
                    
                }
                                
                
                // Selected Items
                // ---------------
                NavigationView {
                    VStack {
                        // Selected Entries List
                        // ----------------------
                        ScrollView { LazyVStack {
                            List {
                                Section ( header: entry_header() .frame(width: geo.size.width * 0.85),
                                          footer: Text("\(selectedPresetEntries.count) items").frame(width: geo.size.width * 0.85, alignment: .leading)
                                ) { ForEach(selectedPresetEntries) { preset_entry in entry_row(entry: preset_entry) } }
                            }.frame(width: geo.size.width, height: geo.size.height * 0.5)
                        }}

                        
                        // Submit Button
                        // --------------
                        VStack {
                            Divider().frame(width: geo.size.width * 0.9)
                            Button("Save Entry") { if selectedPresetEntries.count > 1 { save_multiple_preset() } }
                                .padding(5).frame(width: geo.size.width * 0.9)
                                .background(.cyan).foregroundColor(.white)
                            Spacer()
                        }
                        .frame(height: geo.size.height * 0.1)
                    }
                    
                }.onChange(of: selectedPreset) { _ in
                    if selectedPreset != nil { selectedPresetEntries = Array(selectedPreset!.entries) as! [IndividualPreset]
                    } else { selectedPresetEntries = [] }
                    
                }.frame(height: geo.size.height * 0.6) // end NavigationView
                
                
                Spacer()
                
            }.frame(width: geo.size.width) // end of VStack
        } // end of geo
    } // end of body
    
    
 

    
    
    
    
    
    // Function for saving
    // --------------------
    private func save_multiple_preset() {
        // create the events
        // ------------------
        for preset_entry in selectedPresetEntries {
            let newEvent = UserEvent(context: viewContext)
            newEvent.timestamp = new_date
            newEvent.type      = preset_entry.type
            newEvent.name      = preset_entry.name
            newEvent.quantity  = preset_entry.quantity
            newEvent.units     = preset_entry.units
        }
        // save them all when done (are they all saved at once?)
        // ------------------------
        do { try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    
// end of view struct
}



struct MultiplePresetView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplePresetView( new_date: .constant(Date()) )
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
