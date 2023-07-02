//
//  dataInitHelper.swift
//  murand0
//
//  Created by Andrew Murphy on 7/1/23.
//

import Foundation
import CoreData



/*
private func saveNewIndividualPreset() {
    let newInidividualPreset = IndividualPreset(context: viewContext)
    newInidividualPreset.type     = type
    newInidividualPreset.name     = name
    newInidividualPreset.quantity = quantity
    newInidividualPreset.units    = units
    newInidividualPreset.numberOfUnits  = Int16(numberOfUnits)
    newInidividualPreset.perWeek        = perWeek
    
    do { try viewContext.save()
    } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    
    dataConfig.notifyChanges()
}
*/

/*
 
 Preset:
    name
    type
    quantity
    units
 
 Notifications:
    notifywhenlow
    triggerNotification
    triggerMessage
    perWeek
    triggerDelaySeconds
    notifyBelow
    numberOfUnits
 
*/
func createIndividualPreset(_ presetInfo:           (String, String, Float, String),
                            _ notificationsInfo:    (Bool, Bool, String, Float, Int, Int, Int),
                            _ viewContext:          NSManagedObjectContext,
                            saveOption: Bool = true) {
    // IndividualPreset
    let newInidividualPreset = IndividualPreset(context: viewContext)
    newInidividualPreset.name     = presetInfo.0
    newInidividualPreset.type     = presetInfo.1
    newInidividualPreset.quantity = presetInfo.2
    newInidividualPreset.units    = presetInfo.3
    
    // IndividualPresetNotifications
    let newIndividualPresetNotifications = IndividualPresetNotifications(context: viewContext)
    newIndividualPresetNotifications.notifyWhenLow          = notificationsInfo.0
    newIndividualPresetNotifications.triggerNotification    = notificationsInfo.1
    newIndividualPresetNotifications.triggerMessage         = notificationsInfo.2
    newIndividualPresetNotifications.perWeek                = notificationsInfo.3
    newIndividualPresetNotifications.triggerDelaySeconds    = Int32(notificationsInfo.4)
    newIndividualPresetNotifications.notifyBelow            = Int16(notificationsInfo.5)
    newIndividualPresetNotifications.numberOfUnits          = Int16(notificationsInfo.6)
    
    // Creating Relationship
    newIndividualPresetNotifications.preset = newInidividualPreset
    
    // Saving
    if saveOption {
        do    { try viewContext.save() }
        catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}










