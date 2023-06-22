//
//  GroupPreset+CoreDataProperties.swift
//  murand0
//
//  Created by Andrew Murphy on 6/22/23.
//
//

import Foundation
import CoreData


extension GroupPreset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupPreset> {
        return NSFetchRequest<GroupPreset>(entityName: "GroupPreset")
    }

    @NSManaged public var name: String?
    @NSManaged public var entries: NSSet?

}

// MARK: Generated accessors for entries
extension GroupPreset {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: PresetEntry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: PresetEntry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}

extension GroupPreset : Identifiable {

}
