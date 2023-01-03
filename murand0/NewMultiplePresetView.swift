//
//  NewMultiplePresetView.swift
//  murand0
//
//  Created by Andrew Murphy on 12/31/22.
//

import SwiftUI

struct NewMultiplePresetView: View {
    // Core Data
    // ----------
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \PresetEntry.name, ascending: true)], animation: .default)
    private var preset_entries: FetchedResults<PresetEntry>
    
    // For View
    // ---------
    @State var editMode = EditMode.inactive
    
    @State var selected_presets: Set<PresetEntry> = []
    
    // from parent
    @Binding var new_date: Date
    
    @State var new_name: String = ""

    
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 10) {
                
                // Title
                // ------
                Text("New Multiple Preset:").frame(width: geo.size.width * 0.90, alignment: .leading)
                Divider().frame(width: geo.size.width * 0.90)
                
                
                // Enter Name
                // -----------
                HStack(spacing: 0) {
                    Text("Name:").frame(width: geo.size.width * 0.15, alignment: .leading)
                    TextField("Name", text: $new_name)
                        .padding(3)
                        .frame(width: geo.size.width * 0.75, alignment: .leading)
                        .border(Color.gray, width: 1)
                }.frame(width: geo.size.width * 0.90)


                NavigationView {
                    VStack {
                        
                        // Select Entries to Include
                        // --------------------------
                        HStack(spacing: 0) {
                            Text("Select Entries to Include:")
                            Spacer()
                            EditButton()
                            //Button("Test") { editMode = EditMode.active }
                        }.frame(width: geo.size.width * 0.90)
                        
                        
                        // List the single entries
                        // ------------------------
                        ScrollView {
                            LazyVStack {
                                List(selection: $selected_presets) {
                                    Section (
                                        header: entry_header().frame(width: geo.size.width * 0.85),
                                        footer: Text("\(preset_entries.count) items, \(selected_presets.count) selected").frame(width: geo.size.width * 0.85, alignment: .leading)
                                    ) { ForEach(preset_entries, id: \.self) { entry in entry_row(entry: entry) } }
                                }
                                //.environment(\.editMode, $editMode)
                                .frame(width: geo.size.width, height: geo.size.height * 0.5)
                            }
                        }
                    }
                }
                .frame(height: geo.size.height * 0.5)

                Divider().frame(width: geo.size.width * 0.9)
                
                
                // Finish Button
                // --------------
                Button("Save Entry"){ }
                    .padding(5)
                    .frame(width: geo.size.width * 0.9)
                    .background(.cyan).foregroundColor(.white)
                
                Spacer()
                
                
                
            // end of VStack
            }
            .frame(width: geo.size.width, height: geo.size.height)
        // end of geo
        }
    // end of body
    }
}











struct NewMultiplePresetView_Previews: PreviewProvider {
    static var previews: some View {
        NewMultiplePresetView(new_date: .constant(Date()))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
