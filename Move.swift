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
		if let monsterEntity = NSEntityDescription.entity(forEntityName: "Move", in: context) {
			self.init(entity: monsterEntity, insertInto: context)
			self.name = name
		} else {
			fatalError("Could not initialize Monster Managed Object")
		}
	}

}
