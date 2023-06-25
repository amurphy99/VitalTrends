//
//  Persistence.swift
//  murand0
//
//  Created by Andrew Murphy on 12/11/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        
        
        // my data test
        // -------------
        let sample_date0: Date = Calendar.current.date(byAdding: .minute, value: -30, to: Date())!
        
        let newEvent0 = UserEvent(context: viewContext)
        newEvent0.timestamp = sample_date0
        newEvent0.type      = "Supplement"
        newEvent0.name      = "Caffiene"
        newEvent0.quantity  = 200
        newEvent0.units     = "mg"
        
        let newEvent1 = UserEvent(context: viewContext)
        newEvent1.timestamp = sample_date0
        newEvent1.type      = "Supplement"
        newEvent1.name      = "L-Tyrosine"
        newEvent1.quantity  = 750
        newEvent1.units     = "mg"
        
        let newEvent2 = UserEvent(context: viewContext)
        newEvent2.timestamp = sample_date0
        newEvent2.type      = "Supplement"
        newEvent2.name      = "Phenibut"
        newEvent2.quantity  = 200
        newEvent2.units     = "mg"
        
        let newEvent3 = UserEvent(context: viewContext)
        newEvent3.timestamp = sample_date0
        newEvent3.type      = "Prescription"
        newEvent3.name      = "Concerta"
        newEvent3.quantity  = 54
        newEvent3.units     = "mg"
        
        // earlier day
        // ------------
        let sample_date1: Date = Calendar.current.date(byAdding: .day, value: -1, to: sample_date0)!
        
        let newEvent4 = UserEvent(context: viewContext)
        newEvent4.timestamp = sample_date1
        newEvent4.type      = "Supplement"
        newEvent4.name      = "Caffiene"
        newEvent4.quantity  = 200
        newEvent4.units     = "mg"
        
        let newEvent5 = UserEvent(context: viewContext)
        newEvent5.timestamp = sample_date1
        newEvent5.type      = "Supplement"
        newEvent5.name      = "L-Tyrosine"
        newEvent5.quantity  = 750
        newEvent5.units     = "mg"
        
        let newEvent6 = UserEvent(context: viewContext)
        newEvent6.timestamp = sample_date1
        newEvent6.type      = "Supplement"
        newEvent6.name      = "L-Theanine"
        newEvent6.quantity  = 200
        newEvent6.units     = "mg"
        
        let newEvent7 = UserEvent(context: viewContext)
        newEvent7.timestamp = sample_date1
        newEvent7.type      = "Prescription"
        newEvent7.name      = "Concerta"
        newEvent7.quantity  = 54
        newEvent7.units     = "mg"
        
        // earlier day 2
        // --------------
        /*
        let sample_date2: Date = Calendar.current.date(byAdding: .day, value: -2, to: sample_date0)!
        
        let newEvent8 = UserEvent(context: viewContext)
        newEvent8.timestamp = sample_date2
        newEvent8.type      = "Supplement"
        newEvent8.name      = "Caffiene"
        newEvent8.quantity  = 200
        newEvent8.units     = "mg"
        
        let newEvent9 = UserEvent(context: viewContext)
        newEvent9.timestamp = sample_date2
        newEvent9.type      = "Supplement"
        newEvent9.name      = "L-Tyrosine"
        newEvent9.quantity  = 750
        newEvent9.units     = "mg"
        
        let newEventa = UserEvent(context: viewContext)
        newEventa.timestamp = sample_date2
        newEventa.type      = "Supplement"
        newEventa.name      = "L-Theanine"
        newEventa.quantity  = 200
        newEventa.units     = "mg"
        
        let newEventb = UserEvent(context: viewContext)
        newEventb.timestamp = sample_date2
        newEventb.type      = "Prescription"
        newEventb.name      = "Concerta"
        newEventb.quantity  = 54
        newEventb.units     = "mg"
         */
        
        do { try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        // end of my testing
        
        
        // Creating Sample Presets
        // ------------------------
        
        // entries
        let entry0 = IndividualPreset(context: viewContext)
        entry0.type     = "Supplement"
        entry0.name     = "Caffiene"
        entry0.quantity = 200
        entry0.units    = "mg"
        
        let entry1 = IndividualPreset(context: viewContext)
        entry1.type     = "Supplement"
        entry1.name     = "L-Tyrosine"
        entry1.quantity = 750
        entry1.units    = "mg"
        
        let entry2 = IndividualPreset(context: viewContext)
        entry2.type     = "Supplement"
        entry2.name     = "L-Theanine"
        entry2.quantity = 200
        entry2.units    = "mg"
        
        let entry3 = IndividualPreset(context: viewContext)
        entry3.type     = "Prescription"
        entry3.name     = "Concerta"
        entry3.quantity = 54
        entry3.units    = "mg"
        
        // presets
        let morning = GroupPreset(context: viewContext)
        morning.name = "morning pills"
        morning.addToEntries(entry0)
        morning.addToEntries(entry1)
        morning.addToEntries(entry2)
        morning.addToEntries(entry3)
        
        let redose0 = GroupPreset(context: viewContext)
        redose0.name = "afternoon supplements - no caffiene"
        redose0.addToEntries(entry1)
        redose0.addToEntries(entry2)
        
        let redose1 = GroupPreset(context: viewContext)
        redose1.name = "afternoon supplements - with caffiene"
        redose1.addToEntries(entry0)
        redose1.addToEntries(entry1)
        redose1.addToEntries(entry2)
        
        
        do { try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        // end of sample presets
        
        
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "murand0")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
