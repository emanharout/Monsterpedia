//
//  Monster+CoreDataClass.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 1/2/18.
//  Copyright © 2018 Emmanuoel Haroutunian. All rights reserved.
//
//

import Foundation
import CoreData


public class Monster: NSManagedObject {
	
	convenience init(name: String, id: Int16, types: Set<Type>, genus: String, image2DName: String, spriteImageName: String, context: NSManagedObjectContext){
		if let monsterEntity = NSEntityDescription.entity(forEntityName: "Monster", in: context) {
			self.init(entity: monsterEntity, insertInto: context)
			self.name = name
			self.id = id
			self.genus = genus
			self.isCaught = false
			self.image2DName = image2DName
			self.spriteImageName = spriteImageName
			self.types = types as NSSet?
		} else {
			fatalError("Could not initialize Monster Managed Object")
		}
	}
	
}
