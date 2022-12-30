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
                Text("Multiple Preset:").frame(width: geo.size.width * 0.8, alignment: .leading)
                Divider().frame(width: geo.size.width * 0.8)
                
                
                // Picker
                // -------
                Picker("Multiple Preset Picker", selection: $selectedPreset) {
                    ForEach(preset_events, id: \.self) { preset_event in
                        Text("\(preset_event.name!) (\(preset_event.entries!.count))")
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: selectedPreset) { _ in
                    if selectedPreset != nil {
                        selectedPresetEntries = selectedPreset!.entries!.allObjects as! [PresetEntry]
                    }
                }
                Divider().frame(width: geo.size.width * 0.8)
                
                
                // Selected Items
                // ---------------
                Text("\(selectedPreset?.name! ?? "No Selection")").bold()
                List {
                    Section{
                        ForEach(selectedPresetEntries) { preset_entry in
                            HStack {
                                // Type
                                Text("\(preset_entry.type!)")
                                // Name
                                Text("\(preset_entry.name!)")
                                // Quantity
                                Text("\(myNumberFormatter.string(for: preset_entry.quantity)!) \(preset_entry.units!)")
                                    .frame(width: geo.size.width * 0.15, alignment: .leading)
                            }
                        }
                    }
                    // HEADER
                    header: { VStack(spacing: 3) {
                            // Column Headers
                            HStack(alignment: .center) {
                                Text("Type"     ).frame(width: geo.size.width * 0.3, alignment: .leading)
                                Text("Name"     ).frame(width: geo.size.width * 0.3, alignment: .leading)
                                Text("Quantity" ).frame(width: geo.size.width * 0.2, alignment: .leading)
                            }.font(.system(size: 12))
                            .frame(width: geo.size.width * 0.8, alignment: .leading)
                            Divider().frame(width: geo.size.width * 0.8, alignment: .leading)
                        }
                    }
                    // FOOTER
                    footer: { Text("\(selectedPresetEntries.count) items") }
                }
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
                
                
                
            // end of VStack
            }
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
    }
}
