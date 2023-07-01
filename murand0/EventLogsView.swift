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
    
    @State var showingNewEntry: Bool = false
    @State var dataConfig: modifyDataConfig = modifyDataConfig()
    

    var body: some View {
        NavigationView {
            ZStack {
                EVENTS_GRADIENT.opacity(GRADIENT_OPACITY).ignoresSafeArea()
                VStack {
                    eventLogsDisplay(dataConfig: dataConfig)
                        .animation(.easeIn, value: dataConfig)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){ Text("All Events").font(.title).fontWeight(.semibold) }
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: { showingNewEntry = true }) { Label("Add Item", systemImage: "plus") }
                    }
                }
            }
            .sheet(isPresented: $showingNewEntry) {
                CreateNewLogFromPresetsView(isPresented: $showingNewEntry, dataConfig: $dataConfig)
            }
        } // end NavigationView
        .onAppear {
            
            // only need this if previewing
            //UINavigationBar.appearance().standardAppearance   = navBarStyle()
            //UINavigationBar.appearance().scrollEdgeAppearance = navBarStyle()
        }
    } // end View body

    
    
    // functions to generate log view for page
    // ======================================================

    // split event up by day
    private func splitByDay(results: [UserEvent]) -> [DateComponents : [UserEvent]] {
        var eventsByDay: [DateComponents : [UserEvent]] = [:]
        for val in results {
            // get the date components up to the day only
            let eventDate = Calendar.current.dateComponents([.day, .year, .month], from: val.timestamp)
            
            // add to the dictionary, create a new key for a day if it is not already in
            if eventsByDay.contains(where: { $0.key == eventDate }) {eventsByDay[eventDate]!.append(val)}
            else                                                    {eventsByDay[eventDate] = [val]     }
        }
        return eventsByDay
    }
    
    // function to get the actual display for the page
    private func eventLogsDisplay(dataConfig: modifyDataConfig) -> some View {
        let userEventLogs = loadEventLogs(viewContext: viewContext) // reload the logs
        
        let eventsByDay = splitByDay(results: userEventLogs)
        
        let days: [DateComponents] = Array(eventsByDay.keys)
        let sortedDays: [DateComponents] = days.sorted {
            Calendar.current.date(from: $0) ?? Date.distantFuture >
                Calendar.current.date(from: $1) ?? Date.distantFuture
        }
        
        return ScrollView {
            LazyVStack {
                List {
                    ForEach(sortedDays, id: \.self) { day in
                        Section (header: header_display_date(given_components: day)) {
                            
                            ForEach(eventsByDay[day]!.sorted{$0.timestamp > $1.timestamp}, id: \.self) { eventLog in
                                NavigationLink {
                                    IndividualEventLogView(individualEvent: eventLog, dataConfig: $dataConfig)
                                        .navigationTitle(Text("Edit Entry"))
                                } label: {
                                    HStack {
                                        displayTimeAgo(given_date: eventLog.timestamp)
                                            .fontWeight(.light).font(.system(size: 16))
                                            .frame(width: 65, alignment: .leading)
                                        Text("\(eventLog.name)")
                                        Text("(\(myNumberFormatter.string(for: eventLog.quantity)!) \(eventLog.units ?? ""))")
                                            .fontWeight(.light)
                                            .foregroundColor(.gray)
                                    }
                                    .truncationMode(.tail).lineLimit(1)
                                    .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                }
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
