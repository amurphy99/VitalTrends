//
//  UserEventHelper.swift
//  murand0
//
//  Created by Andrew Murphy on 12/12/22.
//

import Foundation

import SwiftUI





/*
 
 receive list of events
 
 need to separate out based on the day
 
 new lists with day + list of events
 
 
 private var user_events: FetchedResults<UserEvent>
 
 
 */

/*
// function to generate lists of events by day
// --------------------------------------------
func get_events_by_day(results: [UserEvent]) -> [DateComponents : [UserEvent]] {
    // if this day in event days, append to that entry
    // else, create that entry for that day
    
    // return dictionary
    var events_by_day: [DateComponents : [UserEvent]] = [:]
    
    for val in results {
        // get the date components up to the day only
        let event_calendar_date = Calendar.current.dateComponents([.day, .year, .month], from: val.timestamp!)
        
        // add to the dictionary, create a new key for a day if it is not already in
        if events_by_day.contains(where: { $0.key == event_calendar_date }) { events_by_day[event_calendar_date]!.append(val)   }
        else                                                                { events_by_day[event_calendar_date] = [val]        }
    }
    
    return events_by_day
}

// for creating a view from our dict
func display_events_by_day(results: [UserEvent]) {
    // get the dict from other function
    let day_events_dict: [DateComponents : [UserEvent]] = get_events_by_day(results: results)
    let days: [DateComponents] = Array(day_events_dict.keys)
    
    GeometryReader { geo in
        List {
            // for each day in the dictionary
            ForEach(days, id: \.self) { key in
                Section {
                    // show the entries
                    ForEach(day_events_dict[key]!) { user_event in
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
                    //.onDelete(perform: deleteItems(events: results))
                    
                } header: { Text("test")
                } footer: { Text("test footer") }
                
            }
        }
    }
    
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

*/




/*
 
 
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

 
*/






