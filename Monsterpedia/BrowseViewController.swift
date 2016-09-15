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
	var fetchRequest: NSFetchRequest<Monster>!
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
			monsters = try coreDataStack.context.fetch(fetchRequest)
		} catch let error as NSError {
			print(error)
		}
		
		// The following code is added because Xcode falsely thinks there is a bug when exiting BrowseVC while editing team.
		searchController.loadViewIfNeeded()
	}
	
	
	// MARK: SearchResultsController Functions
	func filterContentForSearchText(_ searchText: String, scope: String = "All") {
		filteredMonsters = monsters.filter{ (monster) -> Bool in
			return monster.name.lowercased().contains(searchText.lowercased())
		}
		tableView.reloadData()
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		filterContentForSearchText(searchController.searchBar.text!)
	}
	
	func setupSearchController() {
		searchController.searchResultsUpdater = self
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		
		let searchBar = searchController.searchBar
		searchBar.searchBarStyle = .minimal
		searchBar.backgroundColor = UIColor.white
		searchBar.tintColor = UIColor(red: 240/255, green: 11/255, blue: 49/255, alpha: 1)
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor(red: 240/255, green: 11/255, blue: 49/255, alpha: 1)
		tableView.tableHeaderView = searchBar
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showMonsterDetail" {
			let destinationVC = segue.destination as! MonsterDetailViewController
			destinationVC.selectedMonster = selectedMonster
		}
	}
}



extension BrowseViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != "" {
			return filteredMonsters.count
		}
		return monsters.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "MonsterSpriteCell", for: indexPath) as! MonsterSpriteCell
		
		// TODO: Test and see if can drop casting to NSIndexPath
		let monster: Monster
		if searchController.isActive && searchController.searchBar.text != "" {
			monster = filteredMonsters[(indexPath as NSIndexPath).row]
		} else {
			monster = monsters[(indexPath as NSIndexPath).row]
		}
		
		cell.nameLabel.text = monster.name
		cell.descriptionLabel.text = "\(monster.genus) Pokémon"
		cell.spriteImageView.image = UIImage(named: monster.spriteImageName)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let cell = tableView.cellForRow(at: indexPath) as! MonsterSpriteCell
		let monster = monsters[(indexPath as NSIndexPath).row]
		selectedMonster = monster
		if isTeamBuilding {
			cell.tintColor = UIColor(red: 240/255, green: 11/255, blue: 49/255, alpha: 1)
			cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
			performSegue(withIdentifier: "saveToTeamBuilderTableVC", sender: cell)
		} else {
			performSegue(withIdentifier: "showMonsterDetail", sender: self)
		}
	}
	
	func setupTableView() {
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 88
		
		if !isTeamBuilding {
			let searchBarHeight = searchController.searchBar.bounds.height
			tableView.contentOffset = CGPoint(x: 0, y: searchBarHeight)
		}
	}
}




