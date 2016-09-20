//
//  MonsterInstance+CoreDataProperties.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 9/17/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

extension MonsterInstance {
	
	@NSManaged var name: String
	@NSManaged var id: Int16
	@NSManaged var positionID: Int16
	@NSManaged var genus: String
	@NSManaged var isCaught: Bool
	@NSManaged var image2DName: String
	@NSManaged var spriteImageName: String
	@NSManaged var moves: NSSet?
	@NSManaged var types: NSSet?
	@NSManaged var team: Team?
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<MonsterInstance> {
		return NSFetchRequest<MonsterInstance>(entityName: "MonsterInstance");
	}
	
}
