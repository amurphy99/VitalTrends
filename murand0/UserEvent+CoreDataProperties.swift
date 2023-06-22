//
//  UserEvent+CoreDataProperties.swift
//  murand0
//
//  Created by Andrew Murphy on 6/22/23.
//
//

import Foundation
import CoreData


extension UserEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEvent> {
        return NSFetchRequest<UserEvent>(entityName: "UserEvent")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: Float
    @NSManaged public var timestamp: Date?
    @NSManaged public var type: String?
    @NSManaged public var units: String?

}

extension UserEvent : Identifiable {

}
