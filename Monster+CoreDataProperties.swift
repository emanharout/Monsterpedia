//
//  Monster+CoreDataProperties.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 1/2/18.
//  Copyright © 2018 Emmanuoel Haroutunian. All rights reserved.
//
//

import Foundation
import CoreData


extension Monster {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Monster> {
		return NSFetchRequest<Monster>(entityName: "Monster")
	}
	
	@NSManaged public var name: String
	@NSManaged public var id: Int16
	@NSManaged public var genus: String
	@NSManaged public var isCaught: Bool
	@NSManaged public var image2DName: String
	@NSManaged public var spriteImageName: String
	@NSManaged public var moves: NSSet?
	@NSManaged public var types: NSSet?
	
}

// MARK: Generated accessors for moves
extension Monster {
	
	@objc(addMovesObject:)
	@NSManaged func addToMoves(_ value: Move)
	
	@objc(removeMovesObject:)
	@NSManaged func removeFromMoves(_ value: Move)
	
	@objc(addMoves:)
	@NSManaged func addToMoves(_ values: NSSet)
	
	@objc(removeMoves:)
	@NSManaged func removeFromMoves(_ values: NSSet)
	
}

// MARK: Generated accessors for types
extension Monster {
	
	@objc(addTypesObject:)
	@NSManaged func addToTypes(_ value: Type)
	
	@objc(removeTypesObject:)
	@NSManaged func removeFromTypes(_ value: Type)
	
	@objc(addTypes:)
	@NSManaged func addToTypes(_ values: NSSet)
	
	@objc(removeTypes:)
	@NSManaged func removeFromTypes(_ values: NSSet)
	
}
