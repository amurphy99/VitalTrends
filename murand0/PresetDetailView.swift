//
//  PresetDetailView.swift
//  murand0
//
//  Created by Andrew Murphy on 2/2/23.
//

import SwiftUI

struct PresetDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var entry: PresetEntry
    
    @State var new_type:        String  = ""
    @State var new_name:        String  = ""
    @State var new_quantity:    Float   = 0
    @State var new_units:       String  = ""
    
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .center) {
                // Type, Name, Quantity, Units
                
                
                // Entry Information
                // ------------------
                VStack(alignment: .center) {
                    // Type
                    HStack(spacing: 0) {
                        Text("Type:").frame(width: geo.size.width * 0.20, alignment: .leading); Spacer()
                        TextField("Type", text: $new_type).PDV_textfield(width: geo.size.width)
                    }.frame(width: geo.size.width * 0.9)
                    
                    // Name
                    HStack(spacing: 0) {
                        Text("Name:").frame(width: geo.size.width * 0.20, alignment: .leading); Spacer()
                        TextField("Name", text: $new_name).PDV_textfield(width: geo.size.width)
                    }.frame(width: geo.size.width * 0.9)
                    
                    // Quantity
                    HStack(spacing: 0) {
                        Text("Quantity:").frame(width: geo.size.width * 0.20, alignment: .leading); Spacer()
                        TextField("Quantity", value: $new_quantity, format: .number).PDV_textfield(width: geo.size.width)
                    }.frame(width: geo.size.width * 0.9)
                    
                    // Units
                    HStack(spacing: 0) {
                        Text("Units:").frame(width: geo.size.width * 0.20, alignment: .leading); Spacer()
                        TextField("Units", text: $new_units).PDV_textfield(width: geo.size.width)
                    }.frame(width: geo.size.width * 0.9)
                    
                    
                    Divider().frame(width: geo.size.width * 0.9)
                }
                .onAppear {
                    new_type     = entry.type
                    new_name     = entry.name
                    new_quantity = entry.quantity
                    new_units    = entry.units
                }
                
                
                // Submit Button
                // --------------
                Button("Save Changes") { validate_form() }
                    .padding(5)
                    .frame(width: geo.size.width * 0.9)
                    .background(.cyan).foregroundColor(.white)
                
                
                
                
            }.frame(width: geo.size.width) // end parent VStack
        } // end geo
    } // end View body
    
    
    
    // functions for validating the form data and saving the new entry
    // ----------------------------------------------------------------
    private func validate_form() {
        if new_type.count > 1 {
            if new_name.count > 1 {
                if new_units.count > 1 {
                    // save new event and preset
                    save_new_preset()
                    presentationMode.wrappedValue.dismiss()
                }
                // flash message to enter units
            }
            // flash message to enter a name
        }
        // flash message to enter a type
    }
    
    private func save_new_preset() {
        // create the new PRESET
        // ----------------------
        entry.type     = new_type
        entry.name     = new_name
        entry.quantity = new_quantity
        entry.units    = new_units
        
        // save them both when done
        // -------------------------
        do { try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
    
}










/*
struct PresetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PresetDetailView( entry:  )
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
*/
