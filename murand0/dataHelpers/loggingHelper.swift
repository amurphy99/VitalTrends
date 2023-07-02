//
//  loggingHelper.swift
//  murand0
//
//  Created by Andrew Murphy on 7/1/23.
//

import Foundation
import CoreData




func logFromIndividualPreset(_ preset: IndividualPreset, _ timestamp: Date, _ viewContext: NSManagedObjectContext, saveOption: Bool = true) {
    // Update Stock if there is any
    if preset.numberOfUnits > 0 { preset.numberOfUnits -= 1 }
    
    // Notifications
    // if they are low on stock, notify if it is set
    // if they have a follow-up reminder, trigger it (3 hours from now send notification to do X)
    
    
    // Create the UserEvent from this preset
    // --------------------------------------
    let newEvent = UserEvent(context: viewContext)
    newEvent.timestamp = timestamp
    newEvent.type      = preset.type
    newEvent.name      = preset.name
    newEvent.quantity  = preset.quantity
    newEvent.units     = preset.units
    
    
    // Save newly created event
    // -------------------------
    if saveOption {
        do    { try viewContext.save() }
        catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}



func checkNotifications() {
    
    
}




func logFromGroupPreset(_ preset: GroupPreset, _ timestamp: Date, _ viewContext: NSManagedObjectContext, saveOption: Bool = true) {
    
    // Create each singular event from the GroupPreset, but don't save individually
    // -----------------------------------------------------------------------------
    for individualPreset in preset.entries {
        logFromIndividualPreset(individualPreset, timestamp, viewContext, saveOption: false)
    }
    
    // Save all newly created events
    // ------------------------------
    if saveOption {
        do    { try viewContext.save() }
        catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}














