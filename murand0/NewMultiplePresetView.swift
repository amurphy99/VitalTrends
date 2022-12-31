//
//  NewMultiplePresetView.swift
//  murand0
//
//  Created by Andrew Murphy on 12/31/22.
//

import SwiftUI

struct NewMultiplePresetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \PresetEntry.name, ascending: true)], animation: .default)
    private var preset_entries: FetchedResults<PresetEntry>
    
    @State var selected_presets: Set<PresetEntry> = []
    
    // from parent
    @Binding var new_date: Date
    
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 10) {
                
                // List the single entries
                // ------------------------
                ScrollView {
                    LazyVStack {
                        List(selection: $selected_presets) {
                            Section {
                                ForEach(preset_entries, id: \.self) { preset_entry in
                                    HStack {
                                        // Type
                                        Text("\(preset_entry.type!)")
                                            .frame(width: geo.size.width * 0.25, alignment: .leading)
                                        // Name
                                        Text("\(preset_entry.name!)")
                                            .frame(width: geo.size.width * 0.35, alignment: .leading)
                                        // Quantity
                                        Text("\(myNumberFormatter.string(for: preset_entry.quantity)!) \(preset_entry.units!)")
                                            .frame(width: geo.size.width * 0.2, alignment: .leading)
                                    }
                                }
                            }
                            // HEADER
                            header: {
                                VStack(spacing: 3) {
                                    HStack(alignment: .center) {
                                        Text("Type"     ).frame(width: geo.size.width * 0.25, alignment: .leading)
                                        Text("Name"     ).frame(width: geo.size.width * 0.35, alignment: .leading)
                                        Text("Quantity" ).frame(width: geo.size.width * 0.2, alignment: .leading)
                                    }.font(.system(size: 12))
                                        .frame(width: geo.size.width * 0.8, alignment: .leading)
                                    Divider().frame(width: geo.size.width * 0.8, alignment: .leading)
                                }
                            }
                            // FOOTER
                            footer: {
                                VStack(spacing: 3) {
                                    Text("\(preset_entries.count) items"        )
                                    Text("\(selected_presets.count) selected"   )
                                }
                            }
                        }
                        .frame(width: geo.size.width, height: geo.size.height * 0.6)
                        // TOOLBAR
                        .toolbar { EditButton() }
                    }
                }
                Divider().frame(width: geo.size.width * 0.8)
                
                
                
                
                
                
                
            // end of VStack
            }
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
