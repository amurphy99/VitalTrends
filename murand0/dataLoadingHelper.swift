//
//  dataLoadingHelper.swift
//  murand0
//
//  Created by Andrew Murphy on 6/25/23.
//

import Foundation
import CoreData





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



