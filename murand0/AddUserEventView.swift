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
    
    // background color
    let gradient = LinearGradient(colors: [.orange, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
    var body: some View {
        ZStack {
            // background
            gradient
                .opacity(0.25)
                .ignoresSafeArea()
        
            VStack(alignment: .center) {
                // Title
                Text("Add New Event").font(.title3)
                Divider()
                
                VStack(alignment: .center) {
                    // Default Form Items
                    // ==================================================================================
                    
                    // Date
                    DatePicker("Event Date", selection: $new_date, displayedComponents: [.date, .hourAndMinute])
                    
                    // Select Event Type
                    Picker("Select Event Type", selection: $selectedEvent) {
                        Text("Single"       ).tag(0)
                        Text("Multiple"     ).tag(2)
                        Text("New Single"   ).tag(1)
                        Text("New Multiple" ).tag(3)
                    }
                    .pickerStyle(.segmented)
                    Divider()
                    
                    
                    // Display form for selected type
                    // ==================================================================================
                    VStack(alignment: .center) {
                        if      selectedEvent == 1 { NewEventView           (new_date: $new_date) }
                        else if selectedEvent == 0 { SinglePresetView       (new_date: $new_date) }
                        else if selectedEvent == 2 { MultiplePresetView     (new_date: $new_date) }
                        else if selectedEvent == 3 { NewMultiplePresetView  (new_date: $new_date) }
                    }
                    .padding(.vertical, 10)
                }
            // end parent VStack
            }
            .padding(10)
        // end ZStack
        }
    // end view body
    }
}




struct AddUserEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserEventView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
