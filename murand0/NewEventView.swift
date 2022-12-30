//
//  NewEventView.swift
//  murand0
//
//  Created by Andrew Murphy on 12/29/22.
//

import SwiftUI

struct NewEventView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // from parent view
    @Binding var new_date: Date

    // for single event
    @State var new_type:      String    = ""
    @State var new_name:      String    = ""
    @State var new_quantity:  Float     = 0
    @State var new_units:     String    = ""
    
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(spacing: 10) {
                
                // Title
                // ------
                Text("Single Entry Form:").frame(width: geo.size.width * 0.8, alignment: .leading)
                Divider().frame(width: geo.size.width * 0.8)
                
                
                // Entry Information
                // ------------------
                VStack(alignment: .center) {
                    // Type
                    HStack(spacing: 0) {
                        Text("Type:").frame(width: geo.size.width * 0.20, alignment: .leading)
                        TextField("Type", text: $new_type)
                            .frame(width: geo.size.width * 0.6, alignment: .leading).padding(2).border(Color.gray, width: 1)
                    }.frame(width: geo.size.width * 0.9)
                    
                    // Name
                    HStack(spacing: 0) {
                        Text("Name:").frame(width: geo.size.width * 0.20, alignment: .leading)
                        TextField("Name", text: $new_name)
                            .frame(width: geo.size.width * 0.6, alignment: .leading).padding(2).border(Color.gray, width: 1)
                    }.frame(width: geo.size.width * 0.9)
                    
                    // Quantity
                    HStack(spacing: 0) {
                        Text("Quantity:").frame(width: geo.size.width * 0.20, alignment: .leading)
                        TextField("Quantity", value: $new_quantity, format: .number)
                            .frame(width: geo.size.width * 0.6, alignment: .leading).padding(2).border(Color.gray, width: 1)
                    }.frame(width: geo.size.width * 0.9)
                    
                    // Units
                    HStack(spacing: 0) {
                        Text("Units:").frame(width: geo.size.width * 0.20, alignment: .leading)
                        TextField("Units", text: $new_units)
                            .frame(width: geo.size.width * 0.6, alignment: .leading).padding(2).border(Color.gray, width: 1)
                    }.frame(width: geo.size.width * 0.9)
                    
                    Divider().frame(width: geo.size.width * 0.8)
                }
                
                
                // Submit Button
                // --------------
                Button("Save Entry") {
                    if (new_name != "") {
                        // save new event and preset
                        save_new_preset()
                        // reset form data
                        new_date        = Date()
                        new_type        = ""
                        new_name        = ""
                        new_quantity    = 0
                        new_units       = ""
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
    
    
    // Function for saving (saves the actual event AND saves a new preset entry)
    // --------------------
    func save_new_preset() {
        // create the new EVENT
        // ---------------------
        let newEvent = UserEvent(context: viewContext)
        newEvent.timestamp = new_date
        newEvent.type      = new_type
        newEvent.name      = new_name
        newEvent.quantity  = new_quantity
        newEvent.units     = new_units
        
        // create the new PRESET
        // ----------------------
        let newEntry = PresetEntry(context: viewContext)
        newEntry.type     = new_type
        newEntry.name     = new_name
        newEntry.quantity = new_quantity
        newEntry.units    = new_units
        
        // save them both when done
        // -------------------------
        do { try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventView( new_date: .constant(Date()) )
    }
}
