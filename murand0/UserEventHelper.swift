//
//  UserEventHelper.swift
//  murand0
//
//  Created by Andrew Murphy on 12/12/22.
//

import Foundation

import SwiftUI




func user_entries_row(event: UserEvent)-> some View {
    NavigationLink {
        // new page that you are sent to, with edit button perhaps?
        Text("Item at \(event.timestamp, formatter: myDateFormatter)")
        // include edits for all fields? also add a new text description field to each
        // in the list form, show a * for the ones with a decription entered
    } label: {
        GeometryReader { geo in
            HStack(spacing: geo.size.width * 0.01) {
                // Date
                display_date(given_date: event.timestamp)
                    .frame(width: geo.size.width * 0.42, alignment: .leading)
                // Type
                //Text("\(event.type!)")
                    //.frame(width: geo.size.width * 0.16, alignment: .leading)
                // Name
                Text(event.name)
                    .frame(width: geo.size.width * 0.37, alignment: .leading)
                // Quantity
                Text("\(myNumberFormatter.string(for: event.quantity)!) \(event.units ?? "")")
                    .frame(width: geo.size.width * 0.19, alignment: .leading)
            }
            .font(.system(size: 12))
            .truncationMode(.tail).lineLimit(1)
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}






// ROW FOR SINGLE ENTRY
// ---------------------
func entry_row(entry: IndividualPreset)-> some View {
    NavigationLink { PresetDetailView(entry: entry )
    } label: {
        GeometryReader { geo in
            HStack(spacing: geo.size.width * 0.01) {
                // Type
                Text("\(entry.type)").frame(width: geo.size.width * 0.33, alignment: .leading)
                // Name
                Text("\(entry.name)").frame(width: geo.size.width * 0.42, alignment: .leading)
                // Quantity
                Text("\(myNumberFormatter.string(for: entry.quantity)!) \(entry.units)").frame(width: geo.size.width * 0.23, alignment: .trailing)
            }
            .font(.system(size: 14))
            .truncationMode(.tail).lineLimit(1)
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}


// entry header
// -------------
func entry_header()-> some View {
    GeometryReader { geo in
        VStack(spacing: 3) {
            
            HStack(spacing: geo.size.width * 0.01) {
                Text("Type"     ).frame(width: geo.size.width * 0.33, alignment: .leading)
                Text("Name"     ).frame(width: geo.size.width * 0.42, alignment: .leading)
                Text("Quantity" ).frame(width: geo.size.width * 0.23, alignment: .leading)
            }
            .font(.system(size: 12))
            
            
            Divider().frame(width: geo.size.width * 1.0, alignment: .leading)
            Spacer().frame(height: 3)
        }
        .frame(width: geo.size.width, height: geo.size.height)
    }
}





// func for date column
// ---------------------
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
func displayTimeAgo(given_date: Date)-> some View {
    let interval: TimeInterval = given_date.timeIntervalSinceNow
    
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
    
    return Text("\(test3)")
}




// header date numbers+text
// -------------------------
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





private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


// my custom formatters
// ---------------------
let myNumberFormatter: Formatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 0
    //formatter.currencyCode = "USD"
    //formatter.numberStyle = .currency
    return formatter
}()

let myDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()

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



