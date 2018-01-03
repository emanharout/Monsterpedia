//
//  Team+CoreDataClass.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 1/2/18.
//  Copyright © 2018 Emmanuoel Haroutunian. All rights reserved.
//
//

import Foundation
import CoreData


public class Team: NSManagedObject {
	
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
