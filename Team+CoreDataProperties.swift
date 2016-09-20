//
//  Team+CoreDataProperties.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 9/17/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation
import CoreData

extension Team {
	
	@NSManaged var name: String?
	@NSManaged var monsterInstances: NSOrderedSet?
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
		return NSFetchRequest<Team>(entityName: "Team");
	}
}





// MARK: Generated accessors for monsters
extension Team {
	
	@objc(insertObject:inMonstersAtIndex:)
	@NSManaged public func insertIntoMonsters(_ value: MonsterInstance, at idx: Int)
	
	@objc(removeObjectFromMonstersAtIndex:)
	@NSManaged public func removeFromMonsters(at idx: Int)
	
	@objc(insertMonsters:atIndexes:)
	@NSManaged public func insertIntoMonsters(_ values: [MonsterInstance], at indexes: NSIndexSet)
	
	@objc(removeMonstersAtIndexes:)
	@NSManaged public func removeFromMonsters(at indexes: NSIndexSet)
	
	@objc(replaceObjectInMonstersAtIndex:withObject:)
	@NSManaged public func replaceMonsters(at idx: Int, with value: MonsterInstance)
	
	@objc(replaceMonstersAtIndexes:withMonsters:)
	@NSManaged public func replaceMonsters(at indexes: NSIndexSet, with values: [MonsterInstance])
	
	@objc(addMonstersObject:)
	@NSManaged public func addToMonsters(_ value: MonsterInstance)
	
	@objc(removeMonstersObject:)
	@NSManaged public func removeFromMonsters(_ value: MonsterInstance)
	
	@objc(addMonsters:)
	@NSManaged public func addToMonsters(_ values: NSOrderedSet)
	
	@objc(removeMonsters:)
	@NSManaged public func removeFromMonsters(_ values: NSOrderedSet)
	
}
