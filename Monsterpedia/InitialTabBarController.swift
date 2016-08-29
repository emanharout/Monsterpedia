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
		
		guard let navController = viewControllers?[0] as? UINavigationController else {
			print("Could not inject stack to navController")
			return
		}
		guard let browseVC = navController.topViewController as? BrowseViewController else {
			print("Could not inject stack into browseVC")
			return
		}
		browseVC.coreDataStack = coreDataStack
    }

}

