//
//  Move+CoreDataProperties.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 1/2/18.
//  Copyright © 2018 Emmanuoel Haroutunian. All rights reserved.
//
//

import Foundation
import CoreData


extension Move {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Move> {
        return NSFetchRequest<Move>(entityName: "Move")
    }

    @NSManaged public var name: String
    @NSManaged public var monster: Monster
    @NSManaged var type: Type

}
