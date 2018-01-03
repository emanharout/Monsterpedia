//
//  MonsterInstance+CoreDataProperties.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 1/2/18.
//  Copyright © 2018 Emmanuoel Haroutunian. All rights reserved.
//
//

import Foundation
import CoreData


extension MonsterInstance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MonsterInstance> {
        return NSFetchRequest<MonsterInstance>(entityName: "MonsterInstance")
    }

    @NSManaged public var genus: String?
    @NSManaged public var id: Int16
    @NSManaged public var image2DName: String?
    @NSManaged public var isCaught: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var positionID: Int16
    @NSManaged public var spriteImageName: String
    @NSManaged var team: Team?

}
