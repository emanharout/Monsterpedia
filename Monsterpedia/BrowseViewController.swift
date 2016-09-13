//
//  ViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 7/30/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit
import CoreData

class BrowseViewController: UIViewController, UISearchResultsUpdating {
	
	@IBOutlet weak var tableView: UITableView!
	
	var coreDataStack: CoreDataStack!
	var fetchRequest: NSFetchRequest!
	var monsters = [Monster]()
	var filteredMonsters = [Monster]()
	
	var isTeamBuilding = false
	var selectedMonster: Monster!
	
	let searchController = UISearchController(searchResultsController: nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupSearchController()
		setupTableView()
		
		fetchRequest = NSFetchRequest(entityName: "Monster")
		let sortDesc = NSSortDescriptor(key: "id", ascending: true)
		fetchRequest.sortDescriptors = [sortDesc]
		do {
			monsters = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [Monster]
		} catch let error as NSError {
			print(error)
		}
		
		// The following code is added because Xcode falsely thinks there is a bug when exiting BrowseVC while editing team.
		searchController.loadViewIfNeeded()
	}
	
	
	// MARK: SearchResultsController Functions
	func filterContentForSearchText(searchText: String, scope: String = "All") {
		filteredMonsters = monsters.filter{ (monster) -> Bool in
			return monster.name.lowercaseString.containsString(searchText.lowercaseString)
		}
		tableView.reloadData()
	}
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		filterContentForSearchText(searchController.searchBar.text!)
	}
	
	func setupSearchController() {
		searchController.searchResultsUpdater = self
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		
		let searchBar = searchController.searchBar
		searchBar.searchBarStyle = .Minimal
		searchBar.backgroundColor = UIColor.whiteColor()
		searchBar.tintColor = UIColor(red: 240/255, green: 11/255, blue: 49/255, alpha: 1)
		// TODO: Confirm if public api
		UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).textColor = UIColor(red: 240/255, green: 11/255, blue: 49/255, alpha: 1)
		tableView.tableHeaderView = searchBar
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//		if segue.identifier == "saveToTeamBuilderTableVC" {
//			guard let cell = sender as? MonsterSpriteCell else {
//				print("Downcast to MonsterSpriteCell Failed")
//				return
//			}
//			if let monsterIndexPath = tableView.indexPathForCell(cell) {
//				selectedMonster = monsters[monsterIndexPath.row]
//			}
//		}
		if segue.identifier == "showMonsterDetail" {
			let destinationVC = segue.destinationViewController as! MonsterDetailViewController
			destinationVC.selectedMonster = selectedMonster
		}
	}
}



extension BrowseViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.active && searchController.searchBar.text != "" {
			return filteredMonsters.count
		}
		return monsters.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("MonsterSpriteCell", forIndexPath: indexPath) as! MonsterSpriteCell
		
		let monster: Monster
		if searchController.active && searchController.searchBar.text != "" {
			monster = filteredMonsters[indexPath.row]
		} else {
			monster = monsters[indexPath.row]
		}
		
		cell.nameLabel.text = monster.name
		cell.descriptionLabel.text = "\(monster.genus) Pokémon"
		cell.spriteImageView.image = UIImage(named: monster.spriteImageName)
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		let cell = tableView.cellForRowAtIndexPath(indexPath) as! MonsterSpriteCell
		let monster = monsters[indexPath.row]
		selectedMonster = monster
		if isTeamBuilding {
			cell.tintColor = UIColor(red: 240/255, green: 11/255, blue: 49/255, alpha: 1)
			cell.accessoryType = cell.accessoryType == .Checkmark ? .None : .Checkmark
			performSegueWithIdentifier("saveToTeamBuilderTableVC", sender: cell)
		} else {
			performSegueWithIdentifier("showMonsterDetail", sender: self)
		}
	}
	
	func setupTableView() {
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 88
		
		if !isTeamBuilding {
			let searchBarHeight = searchController.searchBar.bounds.height
			tableView.contentOffset = CGPointMake(0, searchBarHeight)
		}
	}
}




