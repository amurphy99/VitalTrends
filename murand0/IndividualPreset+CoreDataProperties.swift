//
//  IndividualPreset+CoreDataProperties.swift
//  murand0
//
//  Created by Andrew Murphy on 6/24/23.
//
//

import Foundation
import CoreData


extension IndividualPreset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IndividualPreset> {
        return NSFetchRequest<IndividualPreset>(entityName: "IndividualPreset")
    }

    @NSManaged public var name: String
    @NSManaged public var quantity: Float
    @NSManaged public var type: String
    @NSManaged public var units: String
    @NSManaged public var parent_preset: NSSet?

}

// MARK: Generated accessors for parent_preset
extension IndividualPreset {

    @objc(addParent_presetObject:)
    @NSManaged public func addToParent_preset(_ value: GroupPreset)

    @objc(removeParent_presetObject:)
    @NSManaged public func removeFromParent_preset(_ value: GroupPreset)

    @objc(addParent_preset:)
    @NSManaged public func addToParent_preset(_ values: NSSet)

    @objc(removeParent_preset:)
    @NSManaged public func removeFromParent_preset(_ values: NSSet)

}

extension IndividualPreset : Identifiable {

}
