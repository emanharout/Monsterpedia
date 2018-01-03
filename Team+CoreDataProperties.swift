//
//  Team+CoreDataProperties.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 1/2/18.
//  Copyright © 2018 Emmanuoel Haroutunian. All rights reserved.
//
//

import Foundation
import CoreData


extension Team {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team")
    }

    @NSManaged public var name: String?
    @NSManaged public var monsterInstances: Set<MonsterInstance>?

}

// MARK: Generated accessors for monsterInstances
extension Team {

    @objc(addMonsterInstancesObject:)
    @NSManaged public func addToMonsterInstances(_ value: MonsterInstance)

    @objc(removeMonsterInstancesObject:)
    @NSManaged public func removeFromMonsterInstances(_ value: MonsterInstance)

    @objc(addMonsterInstances:)
    @NSManaged public func addToMonsterInstances(_ values: NSSet)

    @objc(removeMonsterInstances:)
    @NSManaged public func removeFromMonsterInstances(_ values: NSSet)

}
