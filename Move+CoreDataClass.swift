//
//  Move+CoreDataClass.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 1/2/18.
//  Copyright © 2018 Emmanuoel Haroutunian. All rights reserved.
//
//

import Foundation
import CoreData


public class Move: NSManagedObject {

	convenience init(name: String, context: NSManagedObjectContext){
		if let monsterEntity = NSEntityDescription.entity(forEntityName: "Move", in: context) {
			self.init(entity: monsterEntity, insertInto: context)
			self.name = name
		} else {
			fatalError("Could not initialize Monster Managed Object")
		}
	}
	
}
