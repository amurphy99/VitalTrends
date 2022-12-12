//
//  UserEventsView.swift
//  murand0
//
//  Created by Andrew Murphy on 12/11/22.
//


import SwiftUI
import CoreData

struct UserEventsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)], animation: .default)
    private var items: FetchedResults<Item>

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \UserEvent.timestamp, ascending: true)], animation: .default)
    private var user_events: FetchedResults<UserEvent>
    
    // other stuff
    @State private var showAddEventForm = false
    
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                // timestamp, type, name, quantity, units
                Spacer().frame(height: 20)
                
                // Headers
                // --------
                HStack(alignment: .center) {
                    Text("Date"     ).bold().frame(width: geo.size.width * 0.3, alignment: .leading)
                    Text("Name"     ).bold().frame(width: geo.size.width * 0.3, alignment: .leading)
                    Text("Quantity" ).bold().frame(width: geo.size.width * 0.2, alignment: .leading)
                }
                .font(.system(size: 14))
                
                
                // Event List
                // -------------
                NavigationView {
                    
                    VStack {
                        Text("User Events").font(.title2)
                        
                        // would be better to sort by timestamp and separate by day
                        List {
                            // Content
                            // --------
                            ForEach(user_events) { user_event in
                                NavigationLink {
                                    // new page that you are sent to, with edit button perhaps?
                                    // something generated elswhere with a function
                                    Text("Item at \(user_event.timestamp!, formatter: myDateFormatter)")
                                    
                                } label: {
                                    // Label = Event Row
                                    HStack(alignment: .center) {
                                        // Date
                                        Text(user_event.timestamp!, formatter: myDateFormatter)
                                            .frame(width: geo.size.width * 0.3, alignment: .leading)
                                        // Name
                                        Text(user_event.name!)
                                            .frame(width: geo.size.width * 0.3, alignment: .leading)
                                        // Quantity
                                        Text("\(myNumberFormatter.string(for: user_event.quantity)!) \(user_event.units!)")
                                            .frame(width: geo.size.width * 0.15, alignment: .leading)
                                    }
                                    .font(.system(size: 12))
                                }
                            }
                            .onDelete(perform: deleteItems)
                        
                        // end List
                        }
                    }
                    

                    
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
                        ToolbarItem{
                            Button(action: { showAddEventForm = true }) { Label("Add Item", systemImage: "plus") }}
                    }
                    Text("Select an item")
                }
                
                
            // end parent VStack
            }
            .sheet(isPresented: $showAddEventForm) {
                NavigationView {
                    AddUserEventView()
                        .toolbar{ ToolbarItem(placement: .confirmationAction) { Button("Close") { showAddEventForm = false } } }
                }
            }
        // end parent geo
        }

        
        
    }

    
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
            offsets.map { items[$0] }.forEach(viewContext.delete)

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
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


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



struct UserEventsView_Previews: PreviewProvider {
    static var previews: some View {
        UserEventsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
