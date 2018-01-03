//
//  ViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 7/30/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit
import CoreData

class MonstersViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var coreDataStack: CoreDataStack!
  var fetchRequest = Monster.fetchRequest() as NSFetchRequest<Monster>
  var monsters = [Monster]()
  var filteredMonsters = [Monster]()
  
  // Vars only utilized when modifying team members
  var isTeamBuilding = false
  var selectedMonster: Monster!
  
  override func viewDidLoad() {
    super.viewDidLoad()
		
		let sortDesc = NSSortDescriptor(keyPath: \Monster.id, ascending: true)
    fetchRequest.sortDescriptors = [sortDesc]
    do {
      monsters = try coreDataStack.context.fetch(fetchRequest)
    } catch let error as NSError {
      print(error)
    }
    
    setupSearchBar()
    setupTableView()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showMonsterDetail" {
      print("Selected Monster in ShowMonsterDetail: \(selectedMonster)")
      let destinationVC = segue.destination as! MonsterDetailViewController
      destinationVC.selectedMonster = selectedMonster
    }
  }
}

// MARK: SearchBar Functions
extension MonstersViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text != "" {
      filteredMonsters = monsters.filter{ (monster) -> Bool in
        return monster.name.lowercased().contains(searchText.lowercased())
      }
    } else {
      filteredMonsters = monsters
    }
    tableView.reloadData()
  }
  
  func setupSearchBar() {
    searchBar.searchBarStyle = .minimal
    searchBar.backgroundColor = UIColor.white
    searchBar.tintColor = UIColor(red: 240/255, green: 11/255, blue: 49/255, alpha: 1)
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor(red: 240/255, green: 11/255, blue: 49/255, alpha: 1)
    filteredMonsters = monsters
  }
}

// MARK: Table View Functions
extension MonstersViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredMonsters.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MonsterSpriteCell", for: indexPath) as! MonsterSpriteCell
    let monster = filteredMonsters[indexPath.row]
    
    cell.nameLabel.text = monster.name
    cell.descriptionLabel.text = "\(monster.genus) Pokémon"
    cell.spriteImageView.image = UIImage(named: monster.spriteImageName)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if searchBar.isFirstResponder {
      searchBar.resignFirstResponder()
    }
    
    let cell = tableView.cellForRow(at: indexPath) as! MonsterSpriteCell
    selectedMonster = filteredMonsters[indexPath.row]
    if isTeamBuilding {
      cell.tintColor = UIColor(red: 240/255, green: 11/255, blue: 49/255, alpha: 1)
      cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
      self.performSegue(withIdentifier: "saveToTeamBuilderTableVC", sender: cell)
    } else {
      performSegue(withIdentifier: "showMonsterDetail", sender: self)
    }
  }
  
  func setupTableView() {
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 88
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    searchBar.resignFirstResponder()
  }
}
