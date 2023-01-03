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
    @Binding    var new_date:      Date
    @State      var new_quantity:  Float = 0

    
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 10) {
                
                // Title
                // ------
                Text("Single Preset: (\(preset_entries.count))").frame(width: geo.size.width * 0.8, alignment: .leading)
                Divider().frame(width: geo.size.width * 0.8)
                
                
                // Picker
                // -------
                Picker("Single Preset Picker", selection: $selectedPreset) {
                    ForEach(preset_entries, id: \.self) { preset_entry in Text(preset_entry.name!) }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: selectedPreset) { _ in
                    if selectedPreset != nil { new_quantity = selectedPreset!.quantity }
                }
                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.1)
                .background(.yellow)
                
                // Entry Information
                // ------------------
                VStack(alignment: .center) {
                    // Type
                    HStack(spacing: 0) {
                        Text("Type:").frame(width: geo.size.width * 0.20, alignment: .leading)
                        Text("\(selectedPreset?.type! ?? "--" )").frame(width: geo.size.width * 0.6, alignment: .leading)
                    }.frame(width: geo.size.width * 0.9)
                    
                    // Name
                    HStack(spacing: 0) {
                        Text("Name:").frame(width: geo.size.width * 0.20, alignment: .leading)
                        Text("\(selectedPreset?.name! ?? "--" )").frame(width: geo.size.width * 0.6, alignment: .leading)
                    }.frame(width: geo.size.width * 0.9)
                    
                    // Quantity
                    HStack(spacing: 0) {
                        Text("Quantity:").frame(width: geo.size.width * 0.20, alignment: .leading)
                        TextField("Quantity", value: $new_quantity, format: .number)
                            .frame(width: geo.size.width * 0.6, alignment: .leading).padding(3).border(Color.gray, width: 1)
                    }
                    .frame(width: geo.size.width * 0.9)
                    
                    // Units
                    HStack(spacing: 0) {
                        Text("Units:").frame(width: geo.size.width * 0.20, alignment: .leading)
                        Text("\(selectedPreset?.units! ?? "--" )").frame(width: geo.size.width * 0.6, alignment: .leading)
                    }.frame(width: geo.size.width * 0.9)
                    
                    Divider().frame(width: geo.size.width * 0.8)
                }

                
                // Submit Button
                // --------------
                Button("Save Entry") {
                    //create and save event
                    if (selectedPreset != nil) {
                        save_single_preset(preset_entry:    selectedPreset!,
                                           new_date:        new_date,
                                           new_quantity:    new_quantity)
                    }
                    // reset form data
                    new_date        = Date()
                    new_quantity    = 0
                }
                .padding(5)
                .frame(width: geo.size.width * 0.9)
                .background(.cyan).foregroundColor(.white)
                
                
                
            // end of VStack
            }
            .frame(width: geo.size.width)
        // end of geo
        }
    // end of body
    }
    
    
    // Function for saving
    // --------------------
    func save_single_preset(preset_entry: PresetEntry, new_date: Date, new_quantity: Float) {
        // create the new event
        // ---------------------
        let newEvent = UserEvent(context: viewContext)
        newEvent.timestamp = new_date
        newEvent.type      = preset_entry.type!
        newEvent.name      = preset_entry.name!
        newEvent.quantity  = new_quantity
        newEvent.units     = preset_entry.units!
        
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
