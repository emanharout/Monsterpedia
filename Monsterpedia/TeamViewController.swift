//
//  TeamViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 8/28/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit
import CoreData

class TeamViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var coreDataStack: CoreDataStack!
	var fetchRequest: NSFetchRequest!
	var frc: NSFetchedResultsController!
	var selectedIndexPath: NSIndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		fetchRequest = NSFetchRequest(entityName: "Team")
		let sortDesc = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [sortDesc]
		frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
		frc.delegate = self
		do {
			try frc.performFetch()
		} catch let error as NSError {
			print(error)
		}
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "addTeam" {
			let destVC = segue.destinationViewController as! UINavigationController
			let teamBuildingVC = destVC.topViewController as! TeamBuilderViewController
			teamBuildingVC.coreDataStack = coreDataStack
		} else if segue.identifier == "viewTeamDetail" {
			let destVC = segue.destinationViewController as! TeamBuilderTableViewController
			destVC.coreDataStack = coreDataStack
			destVC.selectedTeam = frc.objectAtIndexPath(selectedIndexPath) as? Team
			destVC.isTeamDetail = true
		}
	}

	
}



extension TeamViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedIndexPath = indexPath
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		performSegueWithIdentifier("viewTeamDetail", sender: self)
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("TeamCell")!
		let team = frc.objectAtIndexPath(indexPath) as! Team
		cell.textLabel?.text = team.name
		return cell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let count = frc.sections?[section].numberOfObjects {
			return count
		} else {
			return 0
		}
	}
}



extension TeamViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(controller: NSFetchedResultsController) {
		tableView.beginUpdates()
	}
	
	func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
		
		switch type {
		case .Insert:
			tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
		case .Delete:
			tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
		case .Update:
			tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
		case .Move:
			tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
			tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
		}
	}
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		tableView.endUpdates()
	}
}

