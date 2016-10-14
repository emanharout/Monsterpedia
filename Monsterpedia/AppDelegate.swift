//
//  AppDelegate.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 7/30/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	let coreDataStack = CoreDataStack.sharedInstance

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
			print("App has launched before")
		} else {
			print("Is First Launch")
			importSeedData()
			UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
		}
		
		injectCoreDataStack()
		
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		coreDataStack.save()
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		coreDataStack.save()
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	func importSeedData() {
		let seedURL = Bundle.main.url(forResource: "seed", withExtension: "json")!
		// Place below into do-catch
		let seedJSONData = try! Data(contentsOf: seedURL)
		do {
			let JSON = try JSONSerialization.jsonObject(with: seedJSONData, options: .allowFragments) as! [AnyObject]
			for monsterDict in JSON {
				guard let name = monsterDict["name"] as? String, let id = monsterDict["id"] as? Int, let typeArray = monsterDict["type"] as? [String], let genus = monsterDict["genus"] as? String else {
					print("Unable to retrieve Monster information from MonsterDict")
					return
				}
				let image2DName = name.lowercased()
				let spriteImageName = "sprite-front-\(id)"
				
				var typeSet: Set<Type> = Set()
				for type in typeArray {
					let newType = Type(name: type, context: coreDataStack.context)
					typeSet.insert(newType)
				}
				
				_ = Monster(name: name, id: Int16(id), types: typeSet, genus: genus, image2DName: image2DName, spriteImageName: spriteImageName, context: coreDataStack.context)
			}
		} catch let error as NSError {
			print(error)
		}
		coreDataStack.save()
	}
	
	func injectCoreDataStack() {
		guard let tabBarController = window?.rootViewController as? UITabBarController else {
			print("Could not retrieve Initial Tab Bar Controller")
			return
		}
		
		guard let viewControllers = tabBarController.viewControllers as? [UINavigationController] else {
			print("Failed to retrieve reference to Navigation Controllers")
			return
		}
		
		for index in 0...2 {
			let navController = viewControllers[index]
			switch index {
			case 0:
				guard let MonstersVC = navController.topViewController as? MonstersViewController else {
					print("Could not inject stack into MonstersVC")
					continue
				}
				MonstersVC.coreDataStack = coreDataStack
			case 1:
				guard let caughtMonstersVC = navController.topViewController as? CaughtMonstersViewController else {
					print("Could not inject stack into CaughtMonstersViewController")
					continue
				}
				caughtMonstersVC.coreDataStack = coreDataStack
			case 2:
				guard let teamsVC = navController.topViewController as? TeamsViewController else {
					print("Could not inject stack into TeamsVC")
					continue
				}
				teamsVC.coreDataStack = coreDataStack
			default:
				break
			}
		}
	}
}

