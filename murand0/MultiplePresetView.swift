//
//  MultiplePresetView.swift
//  murand0
//
//  Created by Andrew Murphy on 12/30/22.
//

import SwiftUI

struct MultiplePresetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \PresetEvent.name, ascending: true)], animation: .default)
    private var preset_events: FetchedResults<PresetEvent>

    @State var selectedPreset: PresetEvent?
    @State var selectedPresetEntries: [PresetEntry] = []
    
    @Binding var new_date: Date
    
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 10) {
                
                // Title
                // ------
                Text("Multiple Preset:").frame(width: geo.size.width * 0.90, alignment: .leading)
                Divider().frame(width: geo.size.width * 0.90)
                
                
                // Picker Section
                // ---------------
                VStack {
                    
                    Text("Select a Preset:").bold().frame(width: geo.size.width * 0.90, alignment: .leading)
                    
                    // Picker
                    Picker("Multiple Preset Picker", selection: $selectedPreset) {
                        // None option
                        Text("None").tag(PresetEvent?.none)
                        // Other options
                        ForEach(preset_events, id: \.self) { preset_event in
                            Text("\(preset_event.name!) (\(preset_event.entries!.count))")
                                //.frame(width: geo.size.width * 0.90, alignment: .leading)
                                .tag( PresetEvent?.some(preset_event) )
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedPreset) { _ in
                        if selectedPreset != nil {
                            selectedPresetEntries = selectedPreset!.entries!.allObjects as! [PresetEntry]
                        } else { selectedPresetEntries = [] }
                    }
                    
                }
                                
                
                // Selected Items
                // ---------------
                //Text("\(selectedPreset?.name! ?? "No Selection")").bold()
                NavigationView { ScrollView { LazyVStack {
                    List {
                        Section ( header: entry_header() .frame(width: geo.size.width * 0.85),
                                  footer: Text("\(selectedPresetEntries.count) items").frame(width: geo.size.width * 0.85, alignment: .leading)
                        ) { ForEach(selectedPresetEntries) { preset_entry in entry_row(entry: preset_entry) } }
                    }.frame(width: geo.size.width, height: geo.size.height * 0.5)
                }}}.frame(height: geo.size.height * 0.5)
                
                Divider().frame(width: geo.size.width * 0.8)
                
                
                // Submit Button
                // --------------
                Button("Save Entry") {
                    if selectedPresetEntries.count > 1 {
                        // save entries
                        save_multiple_preset(preset_entries: selectedPresetEntries, timestamp: new_date)
                        // clear form data
                        selectedPresetEntries = []
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
    func save_multiple_preset(preset_entries: [PresetEntry], timestamp: Date) {
        // create the events
        // ------------------
        for preset_entry in preset_entries {
            let newEvent = UserEvent(context: viewContext)
            newEvent.timestamp = timestamp
            newEvent.type      = preset_entry.type!
            newEvent.name      = preset_entry.name!
            newEvent.quantity  = preset_entry.quantity
            newEvent.units     = preset_entry.units!
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
