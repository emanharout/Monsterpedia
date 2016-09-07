//
//  Team.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 8/27/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation
import CoreData


class Team: NSManagedObject {

	//init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
	
	convenience init(teamName: String, monsters: Set<Monster>, context: NSManagedObjectContext) {
		if let entityDesc = NSEntityDescription.entityForName("Team", inManagedObjectContext: context) {
			self.init(entity: entityDesc, insertIntoManagedObjectContext: context)
			self.name = teamName
			self.monsters = monsters
		} else {
			fatalError("Failed to create Team managed object")
		}
	}

}
