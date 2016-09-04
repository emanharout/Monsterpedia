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
	@IBOutlet weak var leftBarItem: UIBarButtonItem!
	@IBOutlet weak var rightBarItem: UIBarButtonItem!
	
	var coreDataStack: CoreDataStack!
	var fetchRequest: NSFetchRequest!
	var monsters = [Monster]()
	var filteredMonsters = [Monster]()
	var isTeamBuilding = false
	weak var delegate: TeamBuilderViewController!
	
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
		let textField = searchBar.valueForKey("searchField") as! UITextField
		textField.textColor = UIColor.redColor()
		tableView.tableHeaderView = searchBar
	}
	
	@IBAction func cancel() {
		
	}
	
	@IBAction func save() {
		
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
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		
		if isTeamBuilding {
			cell?.tintColor = UIColor(red: 240/255, green: 11/255, blue: 49/255, alpha: 1)
			cell?.accessoryType = cell?.accessoryType == .Checkmark ? .None : .Checkmark
		} else {
			// TODO: Present EncyclopediaVC
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




