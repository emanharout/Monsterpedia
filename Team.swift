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

	// TODO: Explore storing Array to store monsters instead of 6 MonsterSlots attributes
	
	convenience init(teamName: String, monsters: [Monster?], context: NSManagedObjectContext) {
		if let entityDesc = NSEntityDescription.entity(forEntityName: "Team", in: context) {
			self.init(entity: entityDesc, insertInto: context)
			self.name = teamName
			self.monsterSlot1 = monsters[0]
			self.monsterSlot2 = monsters[1]
			self.monsterSlot3 = monsters[2]
			self.monsterSlot4 = monsters[3]
			self.monsterSlot5 = monsters[4]
			self.monsterSlot6 = monsters[5]
		} else {
			fatalError("Failed to create Team managed object")
		}
	}

}
