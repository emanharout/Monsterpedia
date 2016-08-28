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
		// Override point for customization after application launch.
		
		let tabBarController = window?.rootViewController as! InitialTabBarController
		tabBarController.coreDataStack = coreDataStack
		let tabBarRootViewControllers = tabBarController.viewControllers!
		print(tabBarRootViewControllers)
		if let browseViewController = tabBarRootViewControllers[0] as? BrowseViewController {
			browseViewController.monsters = MonstersManager.sharedInstance.monsters
		}
		if let caughtMonstersViewController = tabBarRootViewControllers[1] as? CaughtMonstersViewController {
			caughtMonstersViewController.monsters = MonstersManager.sharedInstance.monsters
		}
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



}

