//
//  TeamBuilderTableViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 9/4/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

// TODO: Replace SearchController with SearchBar, Refactor Browse and TeamBuilderVC, Remove container view, combine filter array to single

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

	var firstMonster: MonsterInstance?
	var secondMonster: MonsterInstance?
	var thirdMonster: MonsterInstance?
	var fourthMonster: MonsterInstance?
	var fifthMonster: MonsterInstance?
	var sixthMonster: MonsterInstance?
	var selectedMonsters: [MonsterInstance?] {
		let monsters = [firstMonster, secondMonster, thirdMonster, fourthMonster, fifthMonster, sixthMonster]
		return monsters
	}
	
	// Relevant variables when viewing an existing team
	var isTeamDetail = false
	var selectedTeam: Team!
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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupTableView()
		loadTeamIfNeeded()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			teamNameTextField.becomeFirstResponder()
		} else if indexPath.section == 1 {
			let MonstersVC = storyboard?.instantiateViewController(withIdentifier: "MonstersVC") as! MonstersViewController
			MonstersVC.isTeamBuilding = true
			MonstersVC.coreDataStack = coreDataStack
			navigationController?.pushViewController(MonstersVC, animated: true)
		}
		enableEditingModeIfNeeded()
	}
	
	// Unwind Segue after selecting a monster in MonstersViewController
	@IBAction func saveSelectedMonster(_ segue: UIStoryboardSegue, sender: MonsterSpriteCell) {
		if segue.source.isKind(of: MonstersViewController.self) {
			let MonstersVC = segue.source as! MonstersViewController
			guard let monster = MonstersVC.selectedMonster else {
				return
			}
			let monsterInstance = MonsterInstance(name: monster.name, id: monster.id, genus: monster.genus, image2DName: monster.image2DName, spriteImageName: monster.spriteImageName, context: coreDataStack.context)
			let cell: MonsterSpriteCell!
			guard let selectedRowIndex = tableView.indexPathForSelectedRow?.row else {
				return
			}
			
			switch selectedRowIndex {
			case monsterCellNumber.firstCell.rawValue:
				cell = firstMonsterCell
				monsterInstance.positionID = Int16(1)
				firstMonster = monsterInstance
			case monsterCellNumber.secondCell.rawValue:
				monsterInstance.positionID = Int16(2)
				cell = secondMonsterCell
				secondMonster = monsterInstance
			case monsterCellNumber.thirdCell.rawValue:
				monsterInstance.positionID = Int16(3)
				cell = thirdMonsterCell
				thirdMonster = monsterInstance
			case monsterCellNumber.fourthCell.rawValue:
				monsterInstance.positionID = Int16(4)
				cell = fourthMonsterCell
				fourthMonster = monsterInstance
			case monsterCellNumber.fifthCell.rawValue:
				monsterInstance.positionID = Int16(5)
				cell = fifthMonsterCell
				fifthMonster = monsterInstance
			case monsterCellNumber.sixthCell.rawValue:
				monsterInstance.positionID = Int16(6)
				cell = sixthMonsterCell
				sixthMonster = monsterInstance
			default:
				cell = nil
			}
			
			if cell != nil {
				cell.nameLabel.text = monsterInstance.name
				cell.descriptionLabel.text = monsterInstance.genus
				cell.spriteImageView.image = UIImage(named: monsterInstance.spriteImageName)
			}
		}
	}
	
	// If Edit/Done Button Pressed
	@IBAction func rightBarButtonPressed() {
		if !isEditingMode {
			isEditingMode = true
		} else {
			guard let teamName = teamNameTextField.text, !teamName.isEmpty else {
				let alertController = UIAlertController(title: "Team Name Missing", message: "Please enter a name for your team", preferredStyle: .alert)
				let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
				alertController.addAction(okAction)
				present(alertController, animated: true, completion: nil)
				return
			}
			
			selectedTeam.name = teamName
			var newTeamMembers = [MonsterInstance]()
			for monster in selectedMonsters {
				if let monster = monster {
					newTeamMembers.append(monster)
				}
				selectedTeam.monsterInstances = Set(newTeamMembers)
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
			guard let teamMonsters = selectedTeam.monsterInstances else {
				print("The selected team has a monsters property that is nil")
				return
			}
			let monsterCells = [firstMonsterCell, secondMonsterCell, thirdMonsterCell, fourthMonsterCell, fifthMonsterCell, sixthMonsterCell]
			
			for (index, cell) in monsterCells.enumerated() {
				let teamArray = Array(teamMonsters)
				let sortedTeamArray = teamArray.sorted(by: { (monsterA, monsterB) -> Bool in
					monsterA.positionID < monsterB.positionID
				})
				
				switch index {
				case 0:
					firstMonster = sortedTeamArray[index]
				case 1:
					secondMonster = sortedTeamArray[index]
				case 2:
					thirdMonster = sortedTeamArray[index]
				case 3:
					fourthMonster = sortedTeamArray[index]
				case 4:
					fifthMonster = sortedTeamArray[index]
				case 5:
					sixthMonster = sortedTeamArray[index]
				default:
					continue
				}
				
				let monster = sortedTeamArray[index]
				cell?.nameLabel.text = monster.name
				cell?.descriptionLabel.text = monster.genus
				let imageName = monster.spriteImageName
				cell?.spriteImageView.image = UIImage(named: imageName)
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

// MARK: Textfield Methods
extension TeamBuilderTableViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		enableEditingModeIfNeeded()
	}
}
