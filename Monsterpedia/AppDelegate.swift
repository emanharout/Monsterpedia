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


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		if NSUserDefaults.standardUserDefaults().boolForKey("hasLaunchedBefore") {
			print("App has launched before")
		} else {
			print("Is First Launch")
			importSeedData()
			NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLaunchedBefore")
		}
		
		print("WINDOW: \(window)")
		
		guard let tabBarController = window?.rootViewController as? InitialTabBarController else {
			print("Could not retrieve Initial Tab Bar Controller")
			print("ROOT VC: \(window?.rootViewController)")
			return true
		}
		print("ROOT VC: \(window?.rootViewController)")
		tabBarController.coreDataStack = coreDataStack
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		coreDataStack.save()
	}

	func applicationDidEnterBackground(application: UIApplication) {
		coreDataStack.save()
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	func importSeedData() {
		let seedURL = NSBundle.mainBundle().URLForResource("seed", withExtension: "json")!
		let seedJSONData = NSData(contentsOfURL: seedURL)!
		do {
			let JSON = try NSJSONSerialization.JSONObjectWithData(seedJSONData, options: .AllowFragments) as! [AnyObject]
			for monsterDict in JSON {
				guard let name = monsterDict["name"] as? String, let id = monsterDict["id"] as? Int, let typeArray = monsterDict["type"] as? [String], let genus = monsterDict["genus"] as? String else {
					print("Unable to retrieve Monster information from MonsterDict")
					return
				}
				let image2DName = name.lowercaseString
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

}

