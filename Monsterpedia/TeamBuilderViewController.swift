//
//  TeamBuilderViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 9/4/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TeamBuilderViewController: UIViewController {
	
	@IBOutlet weak var containerView: UIView!
	var coreDataStack: CoreDataStack!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "embedTableVC" {
			guard let teamBuilderVC = segue.destination as? TeamBuilderTableViewController else {
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
		let selectedMonsters = childVC.selectedMonsters as [MonsterInstance?]
		var monsterNotSelected = false
		for monster in selectedMonsters {
			if monster == nil {
				monsterNotSelected = true
			}
		}
		if monsterNotSelected {
			let alertController = UIAlertController(title: "Missing Monsters", message: "Please make sure to select six monsters for your team", preferredStyle: .alert)
			let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alertController.addAction(okAction)
			present(alertController, animated: true, completion: nil)
			return
		} else {
			guard let teamName = childVC.teamNameTextField.text , !teamName.isEmpty else {
				let alertController = UIAlertController(title: "Team Name Missing", message: "Please enter a name for your team", preferredStyle: .alert)
				let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
				alertController.addAction(okAction)
				present(alertController, animated: true, completion: nil)
				return
			}
			
			var monsterSet: Set<MonsterInstance> = Set()
			for monster in selectedMonsters {
				if let monster = monster {
					monsterSet.insert(monster)
				}
			}
			
			_ = Team(teamName: teamName, monsters: monsterSet, context: coreDataStack.context)
			coreDataStack.save()
			dismiss(animated: true, completion: nil)
		}
		
		
		
	}
	
	@IBAction func cancelTeamBuilding() {
		self.dismiss(animated: true, completion: nil)
	}
	
}
