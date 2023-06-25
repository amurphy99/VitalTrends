//
//  UserEventsView.swift
//  murand0
//
//  Created by Andrew Murphy on 12/11/22.
//


import SwiftUI
import CoreData

struct UserEventsView2: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserEvent.timestamp, ascending: true)],
        animation: .default
    )
    private var user_events: FetchedResults<UserEvent>
    
    // other stuff
    @State var showAddEventForm = false
    
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                // Title
                // -------
                Text("User Events").font(.title)
                Divider()
                Spacer().frame(height: 5)
                

                // Yolo
                // -----
                NavigationView {
                    display_events_by_day(results: user_events)
                    .toolbar {  ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
                                ToolbarItem{Button(action: { showAddEventForm = true }) { Label("Add Item", systemImage: "plus") }}
                    }
                }
        
            
                
                
                
                
                
                
            } // end parent VStack
            .sheet(isPresented: $showAddEventForm, onDismiss: { showAddEventForm = false }) {
                NavigationView { AddUserEventView()
                        .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { showAddEventForm = false } } }
                }
            }
        } // end parent geo
    } // end View body

    
    
    
    private func addItem() {
        withAnimation {
            let newEvent3 = UserEvent(context: viewContext)
            newEvent3.timestamp = Date()
            newEvent3.type      = "Prescription"
            newEvent3.name      = "Methylphenidate"
            newEvent3.quantity  = 54
            newEvent3.units     = "mg"
            
            
            do { try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { user_events[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    
    // Testing Functions
    // ------------------
    
    // getting dictionary
    func get_events_by_day(results: FetchedResults<UserEvent>) -> [DateComponents : [UserEvent]] {
        // if this day in event days, append to that entry; else, create that entry for that day

        // create return dictionary
        var events_by_day: [DateComponents : [UserEvent]] = [:]
        
        for val in results {
            // get the date components up to the day only
            let event_calendar_date = Calendar.current.dateComponents([.day, .year, .month], from: val.timestamp)
            
            // add to the dictionary, create a new key for a day if it is not already in
            if events_by_day.contains(where: { $0.key == event_calendar_date }) {
                events_by_day[event_calendar_date]!.append(val)}
            else { events_by_day[event_calendar_date] = [val] }
        }
        return events_by_day
    }
    
    // creating view
    func display_events_by_day(results: FetchedResults<UserEvent>) -> some View {
        // get the dict from other function
        let day_events_dict: [DateComponents : [UserEvent]] = get_events_by_day(results: results)
        let days: [DateComponents] = Array(day_events_dict.keys)
        
        return GeometryReader { geo in
            ScrollView {
                LazyVStack {
                    List {
                        // for each day in the dictionary
                        ForEach(days, id: \.self) { key in
                            Section {
                                // show the entries
                                ForEach(day_events_dict[key]!) { user_event in user_entries_row(event: user_event) }
                                    .onDelete(perform: deleteItems)
                            }
                            // HEADER
                            // -------
                            header: { VStack(spacing: 3) {
                                    // Date
                                    header_display_date(given_components: key)
                                        .frame(width: geo.size.width * 0.8, alignment: .leading)
                                    // Column Headers
                                    HStack(alignment: .center) {
                                        Text("Date"     ).frame(width: geo.size.width * 0.3, alignment: .leading)
                                        Text("Name"     ).frame(width: geo.size.width * 0.3, alignment: .leading)
                                        Text("Quantity" ).frame(width: geo.size.width * 0.2, alignment: .leading)
                                    }.font(.system(size: 12))
                                        .frame(width: geo.size.width * 0.8, alignment: .leading)
                                    // Divider Line
                                    Divider().frame(width: geo.size.width * 0.8, alignment: .leading)
                                }
                            .frame(width: geo.size.width * 1.0)
                            }
                            
                            // FOOTER
                            // -------
                            footer: { Text("\(day_events_dict[key]!.count) items") }
                        }
                    }.frame(height: geo.size.height * 0.9)
                }.frame(height: geo.size.height * 0.9)
                
            }//.background(.yellow)
        }//.background(.gray)
    }
    
    // func for date column
    func display_date(given_date: Date)-> some View {
        let test1 = myDateFormatter.string(for: given_date) ?? "no date"
        
        let interval: TimeInterval = given_date.timeIntervalSinceNow
        //let test2 = myIntervalFormatter.string(for: interval) ?? "no interval"
        //let test2 = interval.formatted()
        
        var test3: String = ""
        // /60 = seconds, /60 = hours, /24 = days
        let time_interval = interval as Double
        let days  = time_interval / (60*60*24)
        let hours = time_interval / (60*60)
        let minutes = time_interval / (60)
        
        if      time_interval < -(60*60*24) { test3 = "\(myIntervalFormatter.string(for: -days)!)d ago"}
        else if time_interval < -(60*60)    { test3 = "\(myIntervalFormatter.string(for: -hours)! )h ago" }
        else if time_interval < -60         { test3 = "\(myIntervalFormatter.string(for: -minutes)! )m ago" }
        else if time_interval > -5          { test3 = "just now" }
        else                                { test3 = "\(myIntervalFormatter.string(for: -time_interval)! )s ago" }
        
        return Text("\(test1), \(test3)")
        
    }

    // header date numbers+text
    func header_display_date(given_components: DateComponents) -> some View {
        let header_date: Date = Calendar.current.date(from: given_components)!
        
        let dateFormatterPrint = DateFormatter()
        //dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        //dateFormatterPrint.dateFormat = "EEEE, MMM dd"
        dateFormatterPrint.dateFormat = "E MMM dd"
        
        let simple_date: String = myDateComponentsFormatter.string(for: header_date)!
        
        let text_date: String = dateFormatterPrint.string(from: header_date)
        
        return Text("\(simple_date) - \(text_date)")
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


// my custom formatters
// ---------------------
private let myIntervalFormatter: Formatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 0
    formatter.minimumFractionDigits = 0
    //formatter.currencyCode = "USD"
    //formatter.numberStyle = .currency
    return formatter
}()

private let myDateComponentsFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    //formatter.timeStyle = .none
    //formatter.timeStyle = .short
    return formatter
}()



struct UserEventsView2_Previews: PreviewProvider {
    static var previews: some View {
        UserEventsView2().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
