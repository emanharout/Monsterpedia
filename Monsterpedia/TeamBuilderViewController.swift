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
		guard let browseVC = storyboard?.instantiateViewControllerWithIdentifier("BrowseVC") as? BrowseViewController else {
			print("Instantiation of BrowseVC Failed")
			return
		}
		browseVC.teamBuilding = true
		browseVC.coreDataStack = coreDataStack
		browseVC.delegate = self
		presentViewController(browseVC, animated: true, completion: nil)
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

