//
//  TeamBuilderViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 8/28/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class TeamBuilderViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var coreDataStack: CoreDataStack!

    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	@IBAction func addTeam() {
		
		guard let browseNavController = storyboard?.instantiateViewControllerWithIdentifier("browseMonsterNavigationController") as? UINavigationController else {
			print("Instantiation of BrowseVC Failed")
			return
		}
		guard let browseVC = browseNavController.topViewController as? BrowseViewController else {
			print("Failed to get reference to Browse View Controller")
			return
		}
		browseVC.isTeamBuilding = true
		browseVC.coreDataStack = coreDataStack
		browseVC.delegate = self
		
		let alert = UIAlertController(title: "Enter Team Name", message: nil, preferredStyle: .Alert)
		alert.addTextFieldWithConfigurationHandler { (textField) in
		}
		
		let okAction = UIAlertAction(title: "Ok", style: .Default) { (alertAction) in
			// TODO: Dismiss alert?
			let textField = alert.textFields![0]
			
			if !textField.text!.isEmpty {
				let teamName = textField.text!
				self.presentViewController(browseNavController, animated: true, completion: nil)
			}
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
		alert.addAction(okAction)
		alert.addAction(cancelAction)
		presentViewController(alert, animated: true, completion: nil)
		
		
	}

	
}



extension TeamBuilderViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
}

