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
	var fetchRequest: NSFetchRequest<Team>!
	var frc: NSFetchedResultsController<Team>!
	var selectedIndexPath: IndexPath!
	
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "addTeam" {
			let destVC = segue.destination as! UINavigationController
			let teamBuildingVC = destVC.topViewController as! TeamBuilderViewController
			teamBuildingVC.coreDataStack = coreDataStack
		} else if segue.identifier == "viewTeamDetail" {
			let destVC = segue.destination as! TeamBuilderTableViewController
			destVC.coreDataStack = coreDataStack
			destVC.selectedTeam = frc.object(at: selectedIndexPath)
			destVC.isTeamDetail = true
		}
	}
}

extension TeamViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedIndexPath = indexPath
		tableView.deselectRow(at: indexPath, animated: true)
		performSegue(withIdentifier: "viewTeamDetail", sender: self)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell")!
		let team = frc.object(at: indexPath) as Team
		cell.textLabel?.text = team.name
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let count = frc.sections?[section].numberOfObjects {
			return count
		} else {
			return 0
		}
	}
}

extension TeamViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		
		switch type {
		case .insert:
			tableView.insertRows(at: [newIndexPath!], with: .fade)
		case .delete:
			tableView.deleteRows(at: [indexPath!], with: .fade)
		case .update:
			tableView.reloadRows(at: [indexPath!], with: .fade)
		case .move:
			tableView.deleteRows(at: [indexPath!], with: .fade)
			tableView.insertRows(at: [newIndexPath!], with: .fade)
		}
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
}
