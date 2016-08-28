//
//  Move.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 8/27/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation
import CoreData


class Move: NSManagedObject {

	convenience init(name: String, context: NSManagedObjectContext){
		if let monsterEntity = NSEntityDescription.entityForName("Move", inManagedObjectContext: context) {
			self.init(entity: monsterEntity, insertIntoManagedObjectContext: context)
			self.name = name
		} else {
			fatalError("Could not initialize Monster Managed Object")
		}
	}

}
