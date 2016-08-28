//
//  ViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 7/30/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit
import CoreData

class BrowseViewController: UIViewController, UISearchResultsUpdating, CoreDataComplying {
		
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var viewInTableHeader: UIView!

	var coreDataStack: CoreDataStack!
	var monsters: [String]!
	var filteredMonsters = [String]()
	let searchController = UISearchController(searchResultsController: nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupSearchResultsController()
		setupTableViewRowAttributes()
	}
	
	
	// MARK: SearchResultsController Functions
	func filterContentForSearchText(searchText: String, scope: String = "All") {
		filteredMonsters = monsters.filter{ (monster) -> Bool in
			return monster.lowercaseString.containsString(searchText.lowercaseString)
		}
		tableView.reloadData()
	}
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		filterContentForSearchText(searchController.searchBar.text!)
	}
	
	func setupSearchResultsController() {
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		searchController.hidesNavigationBarDuringPresentation = false
		
		let searchBar = searchController.searchBar
		searchBar.searchBarStyle = .Minimal
		searchBar.translucent = false
		searchBar.tintColor = UIColor(red: 240/255, green: 11/255, blue: 49/255, alpha: 1)
		tableView.tableHeaderView?.backgroundColor = UIColor.whiteColor()
		tableView.tableHeaderView = searchBar
		
		let searchBarHeight = searchController.searchBar.bounds.height
		tableView.contentOffset = CGPointMake(0, searchBarHeight)
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
		let monster: String
		if searchController.active && searchController.searchBar.text != "" {
			monster = filteredMonsters[indexPath.row]
		} else {
			monster = monsters[indexPath.row]
		}
		
		cell.nameLabel.text = monster
		cell.spriteImageView.image = UIImage(named: "sprite-front-\(indexPath.row + 1)")
		return cell
		
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

	}
	
	func setupTableViewRowAttributes() {
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 88
	}
	
}




