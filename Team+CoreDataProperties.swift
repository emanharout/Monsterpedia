//
//  Team+CoreDataProperties.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 9/10/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Team {

	@NSManaged var name: String
    @NSManaged var monsterSlot1: Monster?
    @NSManaged var monsterSlot2: Monster?
    @NSManaged var monsterSlot3: Monster?
    @NSManaged var monsterSlot4: Monster?
    @NSManaged var monsterSlot5: Monster?
    @NSManaged var monsterSlot6: Monster?

}
