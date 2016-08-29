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
		
		for childVC in viewControllers! {
			switch childVC {
			case 0:
				guard let navController = childVC as? UINavigationController else {
					print("Could not retrieve navController that contains BrowseVC")
					continue
				}
				guard let browseVC = navController.topViewController as? BrowseViewController else {
					print("Could not inject stack into browseVC")
					continue
				}
				browseVC.coreDataStack = coreDataStack
			case 1:
				guard let caughtMonstersVC = childVC as? CaughtMonstersViewController else {
					print("Could not inject stack into CaughtMonstersViewController")
					continue
				}
				caughtMonstersVC.coreDataStack = coreDataStack
			case 2:
				guard let navController = childVC as? UINavigationController else {
					print("Could not retrieve navController that contains teamBuilderVC")
					continue
				}
				guard let teamBuilderVC = navController.topViewController as? TeamBuilderViewController else {
					print("Could not inject stack into TeamBuilderVC")
					continue
				}
				teamBuilderVC.coreDataStack = coreDataStack
			default:
				break
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

