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
	
	convenience init(teamName: String, monsters: Set<MonsterInstance>, context: NSManagedObjectContext) {
		if let entityDesc = NSEntityDescription.entity(forEntityName: "Team", in: context) {
			self.init(entity: entityDesc, insertInto: context)
			self.name = teamName
			self.monsterInstances = monsters
		} else {
			fatalError("Failed to create Team managed object")
		}
	}
	
}
