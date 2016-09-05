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
	
	@IBAction func cancelTeamBuilding() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
}