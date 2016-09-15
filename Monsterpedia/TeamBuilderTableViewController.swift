//
//  TeamBuilderTableViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 9/4/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

// TODO: Setup new model where Monsters become MonsterSpecies, and a new entity Monsters are instantiated multiple times in order to be included in Team Sets. Values are passed from each MonsterSpecies selection to create a Monster object, which is then all added to a Team.

import UIKit
import CoreData

class TeamBuilderTableViewController: UITableViewController {
	
	var coreDataStack: CoreDataStack!
	
	@IBOutlet weak var firstMonsterCell: MonsterSpriteCell!
	@IBOutlet weak var secondMonsterCell: MonsterSpriteCell!
	@IBOutlet weak var thirdMonsterCell: MonsterSpriteCell!
	@IBOutlet weak var fourthMonsterCell: MonsterSpriteCell!
	@IBOutlet weak var fifthMonsterCell: MonsterSpriteCell!
	@IBOutlet weak var sixthMonsterCell: MonsterSpriteCell!
	@IBOutlet weak var teamNameTextField: UITextField!
	@IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
	var monsters = [Monster]()
	var firstMonster: Monster?
	var secondMonster: Monster?
	var thirdMonster: Monster?
	var fourthMonster: Monster?
	var fifthMonster: Monster?
	var sixthMonster: Monster?
	var selectedMonsters: [Monster?] {
		let monsters = [firstMonster, secondMonster, thirdMonster, fourthMonster, fifthMonster, sixthMonster]
		return monsters
	}
	
	// Relevant variables when viewing an existing team
	var isTeamDetail = false
	var isEditingMode: Bool = false {
		didSet {
			if isEditingMode {
				rightBarButtonItem.title = "Done"
				navigationItem.setHidesBackButton(true, animated: true)
			} else {
				rightBarButtonItem.title = "Edit"
				navigationItem.setHidesBackButton(false, animated: true)
			}
		}
	}
	var selectedTeam: Team!
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupTableView()
		loadTeamIfNeeded()
		
		let fetchRequest: NSFetchRequest<Monster>! = NSFetchRequest(entityName: "Monster")
		let sortDesc = NSSortDescriptor(key: "id", ascending: true)
		fetchRequest.sortDescriptors = [sortDesc]
		do {
			monsters = try coreDataStack.context.fetch(fetchRequest)
		} catch let error as NSError {
			print(error)
		}
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (indexPath as NSIndexPath).section == 0 {
			teamNameTextField.becomeFirstResponder()
		} else if (indexPath as NSIndexPath).section == 1 {
			let browseVC = storyboard?.instantiateViewController(withIdentifier: "BrowseVC") as! BrowseViewController
			browseVC.isTeamBuilding = true
			browseVC.coreDataStack = coreDataStack
			navigationController?.pushViewController(browseVC, animated: true)
		}
		
		enableEditingModeIfNeeded()
	}
	
	// Unwind Segue after selecting a monster in BrowseViewController
	@IBAction func saveSelectedMonster(_ segue: UIStoryboardSegue, sender: MonsterSpriteCell) {
		if segue.source.isKind(of: BrowseViewController.self) {
			let browseVC = segue.source as! BrowseViewController
			let monster = browseVC.selectedMonster
			let cell: MonsterSpriteCell!
			guard let selectedRowIndex = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row else {
				print("Could not retrieve selected row value")
				return
			}
			
			switch selectedRowIndex {
			case monsterCellNumber.firstCell.rawValue:
				cell = firstMonsterCell
				firstMonster = monster
			case monsterCellNumber.secondCell.rawValue:
				cell = secondMonsterCell
				secondMonster = monster
			case monsterCellNumber.thirdCell.rawValue:
				cell = thirdMonsterCell
				thirdMonster = monster
			case monsterCellNumber.fourthCell.rawValue:
				cell = fourthMonsterCell
				fourthMonster = monster
			case monsterCellNumber.fifthCell.rawValue:
				cell = fifthMonsterCell
				fifthMonster = monster
			case monsterCellNumber.sixthCell.rawValue:
				cell = sixthMonsterCell
				sixthMonster = monster
			default:
				cell = nil
			}
			
			if cell != nil {
				cell.nameLabel.text = monster?.name
				cell.descriptionLabel.text = monster?.genus
				cell.spriteImageView.image = UIImage(named: (monster?.spriteImageName)!)
			}
		}
	}
	
	@IBAction func rightBarButtonPressed() {
		if !isEditingMode {
			isEditingMode = true
		} else {
			guard let teamName = teamNameTextField.text , !teamName.isEmpty else {
				let alertController = UIAlertController(title: "Team Name Missing", message: "Please enter a name for your team", preferredStyle: .alert)
				let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
				alertController.addAction(okAction)
				present(alertController, animated: true, completion: nil)
				return
			}

			selectedTeam.name = teamName
			for (index, monster) in selectedMonsters.enumerated() {
				if monster != nil {
					switch index {
					case 0:
						selectedTeam.monsterSlot1 = monster
					case 1:
						selectedTeam.monsterSlot2 = monster
					case 2:
						selectedTeam.monsterSlot3 = monster
					case 3:
						selectedTeam.monsterSlot4 = monster
					case 4:
						selectedTeam.monsterSlot5 = monster
					case 5:
						selectedTeam.monsterSlot6 = monster
					default:
						continue
					}
				}
			}
			teamNameTextField.resignFirstResponder()
			isEditingMode = false
			coreDataStack.save()
		}
	}
	
	func setupTableView() {
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 88
	}
	
	func loadTeamIfNeeded() {
		if isTeamDetail {
			guard let selectedTeam = selectedTeam else {
				print("Team is nil, could not load contents")
				return
			}
			teamNameTextField.text = selectedTeam.name
			let teamMonsters = [selectedTeam.monsterSlot1, selectedTeam.monsterSlot2, selectedTeam.monsterSlot3, selectedTeam.monsterSlot4, selectedTeam.monsterSlot5, selectedTeam.monsterSlot6]
			let monsterCells = [firstMonsterCell, secondMonsterCell, thirdMonsterCell, fourthMonsterCell, fifthMonsterCell, sixthMonsterCell]
			
			for (index, cell) in monsterCells.enumerated() {
				let monster = teamMonsters[index] 
				cell?.nameLabel.text = monster?.name
				cell?.descriptionLabel.text = monster?.genus
				if let imageName = monster?.spriteImageName {
					cell?.spriteImageView.image = UIImage(named: imageName)
				}
			}
		}
	}
	
	func enableEditingModeIfNeeded() {
		if !isEditingMode && isTeamDetail {
			isEditingMode = true
		}
	}

	enum monsterCellNumber: Int {
		case firstCell = 0, secondCell, thirdCell, fourthCell, fifthCell, sixthCell
	}
}



extension TeamBuilderTableViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		enableEditingModeIfNeeded()
	}
	
}
