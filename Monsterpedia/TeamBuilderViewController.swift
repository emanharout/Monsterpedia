//
//  TeamBuilderViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 9/4/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class TeamBuilderViewController: UIViewController {
	
	@IBOutlet weak var containerView: UIView!
	var coreDataStack: CoreDataStack!

    override func viewDidLoad() {
        super.viewDidLoad()		
    }
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "embedTableVC" {
			guard let teamBuilderVC = segue.destinationViewController as? TeamBuilderTableViewController else {
				print("Failed to inject Core Data Stack into Team Builder Table View Controller")
				return
			}
			teamBuilderVC.coreDataStack = coreDataStack
		}
	}
	
	@IBAction func saveTeam() {
		guard let childVC = childViewControllers.last as? TeamBuilderTableViewController else {
			print("Could not retrieve reference to Team Builder Table View Controller")
			return
		}
		let selectedMonsters = childVC.selectedMonsters
		var monsterNotSelected = false
		for monster in selectedMonsters {
			if monster == nil {
				monsterNotSelected = true
			}
		}
		if monsterNotSelected {
			let alertController = UIAlertController(title: "Missing Monsters", message: "Please make sure to select six monsters", preferredStyle: .Alert)
			let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
			alertController.addAction(okAction)
			presentViewController(alertController, animated: true, completion: nil)
			return
		} else {
			// TODO: Create new team and dismiss VC
		}
		
		
		
	}
	
	@IBAction func cancelTeamBuilding() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
}