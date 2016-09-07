//
//  TeamBuilderTableViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 9/4/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

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
	var firstMonster: Monster?
	var secondMonster: Monster?
	var thirdMonster: Monster?
	var fourthMonster: Monster?
	var fifthMonster: Monster?
	var sixthMonster: Monster?
	@IBOutlet weak var teamNameTextField: UITextField!

	var selectedMonsters: [Monster?] {
		let monsters = [firstMonster, secondMonster, thirdMonster, fourthMonster, fifthMonster, sixthMonster]
		return monsters
	}
	
	// Comptued property returns array of each cells monster name
	// store team name in var
	// fetch monsters with predicate of OR's for each name. put monsters in a Set
	// instantiate and save new team
	// return
	
	var teamMonsters = [Monster]()
	var monsters: NSArray = [Monster]()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 88
		
		let fetchRequest = NSFetchRequest(entityName: "Monster")
		let sortDesc = NSSortDescriptor(key: "id", ascending: true)
		fetchRequest.sortDescriptors = [sortDesc]

		do {
			monsters = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [Monster]
		} catch let error as NSError {
			print(error)
		}
    }
	
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			teamNameTextField.becomeFirstResponder()
		} else if indexPath.section == 1 {
			let browseVC = storyboard?.instantiateViewControllerWithIdentifier("BrowseVC") as! BrowseViewController
			browseVC.isTeamBuilding = true
			browseVC.coreDataStack = coreDataStack
			navigationController?.pushViewController(browseVC, animated: true)
		}
	}
	
	@IBAction func saveSelectedMonster(segue: UIStoryboardSegue, sender: MonsterSpriteCell) {
		if segue.sourceViewController.isKindOfClass(BrowseViewController) {
			let browseVC = segue.sourceViewController as! BrowseViewController
			let monster = browseVC.selectedMonster
			
			let cell: MonsterSpriteCell!
			guard let selectedRowIndex = tableView.indexPathForSelectedRow?.row else {
				print("Could not retrieve selected row value")
				return
			}
			switch selectedRowIndex {
			case monsterCellNumber.FirstCell.rawValue:
				cell = firstMonsterCell
				firstMonster = monster
			case monsterCellNumber.SecondCell.rawValue:
				cell = secondMonsterCell
				secondMonster = monster
			case monsterCellNumber.ThirdCell.rawValue:
				cell = thirdMonsterCell
				thirdMonster = monster
			case monsterCellNumber.FourthCell.rawValue:
				cell = fourthMonsterCell
				fourthMonster = monster
			case monsterCellNumber.FifthCell.rawValue:
				cell = fifthMonsterCell
				fifthMonster = monster
			case monsterCellNumber.SixthCell.rawValue:
				cell = sixthMonsterCell
				sixthMonster = monster
			default:
				cell = nil
			}
			if cell != nil {
				cell.nameLabel.text = monster.name
				cell.descriptionLabel.text = monster.genus
				cell.spriteImageView.image = UIImage(named: monster.spriteImageName)
			}
		}
	}
	
	@IBAction func cancelSelectMonster(segue: UIStoryboardSegue) {
		
	}

	enum monsterCellNumber: Int {
		case FirstCell = 0, SecondCell, ThirdCell, FourthCell, FifthCell, SixthCell
	}
}



