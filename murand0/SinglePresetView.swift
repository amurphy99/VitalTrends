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
    
    // for single event
    @Binding var new_date:      Date
    @Binding var new_type:      String
    @Binding var new_name:      String
    @Binding var new_quantity:  Float
    @Binding var new_units:     String

    
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack(alignment: .center, spacing: 10) {
                
                // Title
                // ------
                Text("Single Preset:").frame(width: geo.size.width * 0.8, alignment: .leading)
                Divider().frame(width: geo.size.width * 0.8)
                
                
                // Picker
                // -------
                Picker("Preset Picker", selection: $selectedPreset) {
                    ForEach(preset_entries, id: \.self) { preset_entry in Text(preset_entry.name!) }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: selectedPreset) { _ in
                    if selectedPreset != nil {
                        new_type        = selectedPreset!.type!
                        new_name        = selectedPreset!.name!
                        new_quantity    = selectedPreset!.quantity
                        new_units       = selectedPreset!.units!
                    }
                }
                
                
                // Type
                // -----
                HStack(spacing: 0) {
                    Text("Type:").frame(width: geo.size.width * 0.20, alignment: .leading)
                    TextField("Type", text: $new_type)
                        .frame(width: geo.size.width * 0.6, alignment: .leading).padding(2).border(Color.gray, width: 1)
                }
                .frame(width: geo.size.width * 0.9)
                
                // Name
                // -----
                HStack(spacing: 0) {
                    Text("Name:").frame(width: geo.size.width * 0.20, alignment: .leading)
                    TextField("Name", text: $new_name)
                        .frame(width: geo.size.width * 0.6, alignment: .leading).padding(2).border(Color.gray, width: 1)
                }
                .frame(width: geo.size.width * 0.9)
                
                // Quantity
                // ---------
                HStack(spacing: 0) {
                    Text("Quantity:").frame(width: geo.size.width * 0.20, alignment: .leading)
                    TextField("Quantity", value: $new_quantity, format: .number)
                        .frame(width: geo.size.width * 0.6, alignment: .leading).padding(2).border(Color.gray, width: 1)
                }
                .frame(width: geo.size.width * 0.9)
                
                // Units
                // ------
                HStack(spacing: 0) {
                    Text("Units:").frame(width: geo.size.width * 0.20, alignment: .leading)
                    TextField("Units", text: $new_units)
                        .frame(width: geo.size.width * 0.6, alignment: .leading).padding(2).border(Color.gray, width: 1)
                }
                .frame(width: geo.size.width * 0.9)
                Divider().frame(width: geo.size.width * 0.8)
                
                
                // Submit Button
                // --------------
                Button("Save Entry") {
                    //create and save event
                    let newEvent = UserEvent(context: viewContext)
                    newEvent.timestamp = new_date
                    newEvent.type      = new_type
                    newEvent.name      = new_name
                    newEvent.quantity  = new_quantity
                    newEvent.units     = new_units
                    
                    do { try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                    // reset form data
                    new_date        = Date()
                    new_type        = ""
                    new_name        = ""
                    new_quantity    = 0
                    new_units       = ""
                }
                         
            }
            
        // end of VStack
        }
    // end of geo
    }
}

struct SinglePresetView_Previews: PreviewProvider {
    static var previews: some View {
        SinglePresetView(new_date:      .constant(Date()),
                         new_type:      .constant(""),
                         new_name:      .constant(""),
                         new_quantity:  .constant(0),
                         new_units:     .constant("")
        )
    }
}
