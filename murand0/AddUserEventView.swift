//
//  AddUserEventView.swift
//  murand0
//
//  Created by Andrew Murphy on 12/11/22.
//

import SwiftUI

struct AddUserEventView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \PresetEvent.name, ascending: true)], animation: .default)
    private var preset_events:  FetchedResults<PresetEvent>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \PresetEntry.name, ascending: true)], animation: .default)
    private var preset_entries: FetchedResults<PresetEntry>
    
    
    // Form Variables
    // ---------------
    @State private var date = Date()
    @State private var selectedEvent = 0
    
    @State private var selectedPreset: PresetEvent?
    
    // for single event
    @State private var new_type:        String  = ""
    @State private var new_name:        String  = ""
    @State private var new_quantity:    Float   = 0
    @State private var new_units:       String  = ""
    
    
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .center) {
                HStack{ Spacer() }
                
                Text("Add New Event").font(.title3)
                Divider().frame(width: geo.size.width * 0.9)
                
            
                // Actual Form Start
                // ------------------
                VStack{
                    // Date
                    // -----
                    DatePicker("Event Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    
                    // Select Event Type
                    // ------------------
                    Picker("Select Event Type", selection: $selectedEvent) {
                        Text("Single Entry" ).tag(0)
                        Text("Preset Entry" ).tag(1)
                        Text("Text Entry"   ).tag(2)
                    }
                    .pickerStyle(.segmented)
                    
                    
                    // Display form for selected type
                    // -------------------------------
                    VStack {
                        Text("(\(selectedEvent))  ").frame(width: geo.size.width * 0.9, alignment: .trailing)
                        
                        
                        // Single Event Form
                        // ------------------
                        if selectedEvent == 0 {
                            NewEventView(new_type:      $new_type,
                                         new_name:      $new_name,
                                         new_quantity:  $new_quantity,
                                         new_units:     $new_units)
                        }
                        
                        
                        // Preset Event Form
                        // ------------------
                        else if selectedEvent == 1 {
                            
                            Picker("Preset Picker", selection: $selectedPreset) {
                                ForEach(preset_events, id: \.self) { preset_event in Text(preset_event.name!).tag(preset_event) }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            if selectedPreset != nil {
                                Text("You selected option number \(selectedPreset!.name!)")
                                get_preset_card(preset_event: selectedPreset!)
                            }
                            else { Text("Selected Preset is nil") }
                        
                        }
                        

                        // Text Event Form
                        // ----------------
                        else if selectedEvent == 2 {
                            Text("Text Entry Form")
                        }
                        
                        
                    }
                    .frame(width: geo.size.width * 0.9)
                    .padding(.vertical, 10)
                    .background(.yellow)
                    
                    
                    // Submit Button
                    // --------------
                    Button("Save Entry") {
                        // use the selectedEvent variable to know what form info to use
                        if selectedEvent == 0 {
                            
                            //create and save event
                            let newEvent = UserEvent(context: viewContext)
                            newEvent.timestamp = date
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
                            date            = Date()
                            new_type        = ""
                            new_name        = ""
                            new_quantity    = 0
                            new_units       = ""
                             
                        }
                        
                        
                    }
                        .padding(5)
                        .frame(width: geo.size.width * 0.9)
                        .background(.cyan)
                        .foregroundColor(.white)
                    
                    
                }
                .frame(width: geo.size.width * 0.9)

                
            
                
                        
            // end parent VStack
            }
        // end geo
        }
    // end view body
    }
}



// custom preset "card" generator function
// ----------------------------------------
func get_preset_card(preset_event: PresetEvent) -> some View {
    
    GeometryReader { geo in
        VStack(spacing: 0) { HStack{ Spacer() }

            // Event Title
            // ------------
            Text("\(preset_event.name!) (\(preset_event.entries!.count))")
                .font(.system(size: 16))
                .frame(width: geo.size.width * 0.9, alignment: .leading)
            Divider().frame(width: geo.size.width * 0.9, height: 10)
            
            // Event Entries
            // --------------
            let temp: [PresetEntry] = preset_event.entries!.allObjects as! [PresetEntry]
            ForEach(temp, id: \.self) {preset_entry in
                HStack(alignment: .center) {
                    // Type
                    Text(preset_entry.type!).frame(width: geo.size.width * 0.30, alignment: .leading)
                    // Name
                    Text(preset_entry.name!).frame(width: geo.size.width * 0.40, alignment: .leading)
                    // Quantity and Units
                    Text("\(myNumberFormatter.string(for: preset_entry.quantity)!) \(preset_entry.units!)")
                        .frame(width: geo.size.width * 0.15, alignment: .leading)
                }
                .font(.system(size: 14))
            }
        }
        .padding(.vertical, 5)
        .background(.yellow)
    }
    //.background(.cyan)
}



// my custom formatters
// ---------------------
private let myNumberFormatter: Formatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 0
    //formatter.currencyCode = "USD"
    //formatter.numberStyle = .currency
    return formatter
}()

private let myDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    //formatter.timeStyle = .none
    formatter.timeStyle = .short
    return formatter
}()




struct AddUserEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserEventView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
