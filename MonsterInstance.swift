//
//  MonsterInstance+CoreDataClass.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 9/17/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


class MonsterInstance: NSManagedObject {
	
	convenience init(name: String, id: Int16, genus: String, image2DName: String, spriteImageName: String, context: NSManagedObjectContext){
		if let monsterEntity = NSEntityDescription.entity(forEntityName: "MonsterInstance", in: context) {
			self.init(entity: monsterEntity, insertInto: context)
			self.name = name
			self.id = id
			self.genus = genus
			self.isCaught = false
			self.image2DName = image2DName
			self.spriteImageName = spriteImageName
		} else {
			fatalError("Could not initialize Monster Managed Object")
		}
	}
	
	convenience init(monster: Monster, context: NSManagedObjectContext){
		if let monsterEntity = NSEntityDescription.entity(forEntityName: "MonsterInstance", in: context) {
			self.init(entity: monsterEntity, insertInto: context)
			self.name = monster.name
			self.id = monster.id
			self.genus = monster.genus
			self.isCaught = false
			self.image2DName = monster.image2DName
			self.spriteImageName = monster.spriteImageName
		} else {
			fatalError("Could not initialize Monster Managed Object")
		}
	}
}
