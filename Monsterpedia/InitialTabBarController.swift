//
//  InitialTabBarController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 8/27/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class InitialTabBarController: UITabBarController {
	
	var coreDataStack: CoreDataStack!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		for childVC in childViewControllers {
			if let childVC = childVC as? CoreDataComplying {
				var childVC = childVC
				childVC.coreDataStack = coreDataStack
			}
		}
    }

}

