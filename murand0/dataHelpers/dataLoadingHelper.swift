//
//  dataLoadingHelper.swift
//  murand0
//
//  Created by Andrew Murphy on 6/25/23.
//

import Foundation
import CoreData




// Load list of  individual presets
func loadIndividualPresets(viewContext: NSManagedObjectContext) -> [IndividualPreset] {
    let request = IndividualPreset.fetchRequest()
    let sort = NSSortDescriptor(key: "name", ascending: false)
    request.sortDescriptors = [sort]
    
    var results = [IndividualPreset]()
    
    do {
        results = try viewContext.fetch(request)
        print("Got \(results.count) commits")
    } catch { print("Fetch failed") }
    
    return results
}


// Load list of  group presets
func loadGroupPresets(viewContext: NSManagedObjectContext) -> [GroupPreset] {
    let request = GroupPreset.fetchRequest()
    let sort = NSSortDescriptor(key: "name", ascending: false)
    request.sortDescriptors = [sort]
    
    var results = [GroupPreset]()
    
    do {
        results = try viewContext.fetch(request)
        print("Got \(results.count) commits")
    } catch { print("Fetch failed") }
    
    return results
}


// Load list of event logs
func loadEventLogs(viewContext: NSManagedObjectContext) -> [UserEvent] {
    let request = UserEvent.fetchRequest()
    let sort = NSSortDescriptor(key: "name", ascending: false)
    request.sortDescriptors = [sort]
    
    var results = [UserEvent]()
    
    do {
        results = try viewContext.fetch(request)
        print("Got \(results.count) commits")
    } catch { print("Fetch failed") }
    
    return results
}



// Load list of event logs
func loadIndividualPresetNotifications(viewContext: NSManagedObjectContext) -> [IndividualPresetNotifications] {
    let request = IndividualPresetNotifications.fetchRequest()
    //let sort = NSSortDescriptor(key: "name", ascending: false)
    //request.sortDescriptors = [sort]
    //let condition: Bool = true
    //request.predicate = NSPredicate(format: "isSet == %@", condition)
    
    var results = [IndividualPresetNotifications]()
    
    do {
        results = try viewContext.fetch(request)
        print("Got \(results.count) commits")
    } catch { print("Fetch failed") }
    
    return results
}



