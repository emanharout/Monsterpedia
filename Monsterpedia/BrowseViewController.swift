//
//  ViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 7/30/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UISearchResultsUpdating {
	
		
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var viewInTableHeader: UIView!
	var segmentedControl: UISegmentedControl!
	
	var monsters: [String]!
	var filteredMonsters = [String]()
	let searchController = UISearchController(searchResultsController: nil)
	

	override func viewDidLoad() {
		super.viewDidLoad()
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		searchController.hidesNavigationBarDuringPresentation = false
		
		let searchBar = searchController.searchBar
		searchBar.searchBarStyle = .Prominent
		searchBar.tintColor = UIColor(red: 240/255, green: 11/255, blue: 49/255, alpha: 1)
		searchBar.translucent = false
		searchBar.showsCancelButton = false
		searchBar.backgroundColor = UIColor.blackColor()
		tableView.tableHeaderView = searchBar
		
		segmentedControl = UISegmentedControl(items: ["sad", "Asdas"])
				
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 88
		let searchBarHeight = searchController.searchBar.bounds.height
		tableView.contentOffset = CGPointMake(0, searchBarHeight)
		
		print(monsters)
		
	}
	
	func filterContentForSearchText(searchText: String, scope: String = "All") {
		filteredMonsters = monsters.filter{ (monster) -> Bool in
			return monster.lowercaseString.containsString(searchText.lowercaseString)
		}
		print(filteredMonsters)
		tableView.reloadData()
	}
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		filterContentForSearchText(searchController.searchBar.text!)
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
	
}




