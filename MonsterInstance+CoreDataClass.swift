//
//  MonsterInstance+CoreDataClass.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 1/2/18.
//  Copyright © 2018 Emmanuoel Haroutunian. All rights reserved.
//
//

import Foundation
import CoreData


public class MonsterInstance: NSManagedObject {

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
