//
//  IndividualPresetNotifications+CoreDataProperties.swift
//  murand0
//
//  Created by Andrew Murphy on 7/1/23.
//
//

import Foundation
import CoreData


extension IndividualPresetNotifications {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IndividualPresetNotifications> {
        return NSFetchRequest<IndividualPresetNotifications>(entityName: "IndividualPresetNotifications")
    }

    @NSManaged public var numberOfUnits: Int16
    @NSManaged public var perWeek: Float
    @NSManaged public var notifyWhenLow: Bool
    @NSManaged public var notifyBelow: Int16
    @NSManaged public var triggerNotification: Bool
    @NSManaged public var triggerMessage: String?
    @NSManaged public var triggerDelaySeconds: Int32
    @NSManaged public var preset: IndividualPreset?

}

extension IndividualPresetNotifications : Identifiable {

}
