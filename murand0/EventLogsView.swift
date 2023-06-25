//
//  EventLogsView.swift
//  murand0
//
//  Created by Andrew Murphy on 6/24/23.
//

import SwiftUI

struct EventLogsView: View {
    
    // CoreData
    @Environment(\.managedObjectContext) private var viewContext
    @State var userEventLogs = [UserEvent]()
    
    let gradient = LinearGradient(colors: [.orange, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
    var body: some View {
        NavigationView {
            ZStack {
                gradient.opacity(0.25).ignoresSafeArea()
                VStack {
                
                    eventLogsDisplay()
                    
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){ Text("All Events").font(.title).fontWeight(.semibold) }
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {  }) { Label("Add Item", systemImage: "plus") }
                    }
                }
            }
        } // end NavigationView
        .onAppear {
            loadData()
            
            let appearance = UINavigationBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            //appearance.backgroundColor = UIColor(Color.orange.opacity(0.1))
            
            UINavigationBar.appearance().standardAppearance = appearance // Inline appearance (standard height appearance)
            UINavigationBar.appearance().scrollEdgeAppearance = appearance // Large Title appearance
        }
    } // end View body

    
    // functions to load in data for the page
    // ======================================================
    private func loadData() {
        loadEventLogs()
    }
    private func loadEventLogs() {
        let request = UserEvent.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            userEventLogs = try viewContext.fetch(request)
            print("Got \(userEventLogs.count) commits")
        } catch { print("Fetch failed") }
    }
    // split event up by day
    private func splitByDay(results: [UserEvent]) -> [DateComponents : [UserEvent]] {
        var eventsByDay: [DateComponents : [UserEvent]] = [:]
        for val in results {
            // get the date components up to the day only
            let eventDate = Calendar.current.dateComponents([.day, .year, .month], from: val.timestamp!)
            
            // add to the dictionary, create a new key for a day if it is not already in
            if eventsByDay.contains(where: { $0.key == eventDate }) {eventsByDay[eventDate]!.append(val)}
            else                                                    {eventsByDay[eventDate] = [val]     }
        }
        return eventsByDay
    }
    
    // function to get the actual display for the page
    private func eventLogsDisplay() -> some View {
        let eventsByDay = splitByDay(results: userEventLogs)
        //let sortedDays = eventsByDay.sorted( by: { $0.0.day < $1.0.day })
        let days: [DateComponents] = Array(eventsByDay.keys)
        
        return ScrollView {
            LazyVStack {
                List {
                    ForEach(days, id: \.self) { day in
                        Section (header: header_display_date(given_components: day)) {
                            ForEach(eventsByDay[day]!, id: \.self) { eventLog in
                                
                                NavigationLink {
                                    Text("\(eventLog.name!)")
                                        .navigationTitle(Text("\(eventLog.name!)"))
                                } label: { Text("\(eventLog.name!)") }
                                
                                
                                
                                
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(height: UIScreen.main.bounds.height)
            }
        }
    }
    
    
    
    
    
    
}

struct EventLogsView_Previews: PreviewProvider {
    static var previews: some View {
        EventLogsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
