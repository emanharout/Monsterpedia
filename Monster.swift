//
//  Monster.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 8/27/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation
import CoreData


class Monster: NSManagedObject {

//	init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
//		<#code#>
//	}

	convenience init(name: String, id: Int16, types: Set<Type>, genus: String, image2DName: String, spriteImageName: String, context: NSManagedObjectContext){
		if let monsterEntity = NSEntityDescription.entityForName("Monster", inManagedObjectContext: context) {
			self.init(entity: monsterEntity, insertIntoManagedObjectContext: context)
			self.name = name
			self.id = id
			self.genus = genus
			self.isCaught = false
			self.image2DName = image2DName
			self.spriteImageName = spriteImageName
			self.types = types
		} else {
			fatalError("Could not initialize Monster Managed Object")
		}
	}
}
