//
//  AddUserEventView.swift
//  murand0
//
//  Created by Andrew Murphy on 12/11/22.
//

import SwiftUI

struct AddUserEventView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // Form Variables
    // ---------------
    @State var new_date = Date()
    @State var selectedEvent = 0
    
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .center) { HStack{ Spacer() }
                
                // Title
                // ------
                Text("Add New Event").font(.title3)
                Divider().frame(width: geo.size.width * 0.9)
                
                
                // Actual Form Start
                // ------------------
                VStack{
                    // Date
                    // -----
                    DatePicker("Event Date", selection: $new_date, displayedComponents: [.date, .hourAndMinute])
                    
                    
                    // Select Event Type
                    // ------------------
                    Picker("Select Event Type", selection: $selectedEvent) {
                        Text("New Event"        ).tag(0)
                        Text("Single Preset"    ).tag(1)
                        Text("Multiple Preset"  ).tag(2)
                    }
                    .pickerStyle(.segmented)
                    
                    
                    // Display form for selected type
                    // -------------------------------
                    VStack {
                        Text("(\(selectedEvent))  ").frame(width: geo.size.width * 0.9, alignment: .trailing)
                        
                        if      selectedEvent == 0 { NewEventView       (new_date: $new_date) }
                        else if selectedEvent == 1 { SinglePresetView   (new_date: $new_date) }
                        else if selectedEvent == 2 { MultiplePresetView (new_date: $new_date) }
                        
                    }
                    .frame(width: geo.size.width * 0.9)
                    .padding(.vertical, 10)
                    .background(.yellow)
                    
                }
                .frame(width: geo.size.width * 0.9)

                
                        
            // end parent VStack
            }
        // end geo
        }
    // end view body
    }
}




struct AddUserEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserEventView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
