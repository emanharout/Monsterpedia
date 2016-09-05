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
	
	@IBOutlet weak var firstMonster: MonsterSpriteCell!
	@IBOutlet weak var secondMonster: MonsterSpriteCell!
	@IBOutlet weak var thirdMonster: MonsterSpriteCell!
	@IBOutlet weak var fourthMonster: MonsterSpriteCell!
	@IBOutlet weak var fifthMonster: MonsterSpriteCell!
	@IBOutlet weak var sixthMonster: MonsterSpriteCell!
	@IBOutlet weak var teamNameTextField: UITextField!
	var teamMonsters = [Monster]()
	var monsters = [Monster]()
	var selectedRow: Int!
	
	
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
			selectedRow = indexPath.row
			let browseVC = storyboard?.instantiateViewControllerWithIdentifier("BrowseVC") as! BrowseViewController
			browseVC.isTeamBuilding = true
			browseVC.coreDataStack = coreDataStack
			browseVC.selectedIndexPath = indexPath
			navigationController?.pushViewController(browseVC, animated: true)
		}
	}
	
//	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//		
//	}
	
	@IBAction func saveSelectedMonster(segue: UIStoryboardSegue, sender: MonsterSpriteCell) {
		if segue.sourceViewController.isKindOfClass(BrowseViewController) {
			let browseVC = segue.sourceViewController as! BrowseViewController
			let indexPath = browseVC.selectedIndexPath
			let monster = monsters[indexPath.row]
			
			if let selectedRowIndex = monsterCellNumber(rawValue: selectedRow) {
				let cell: MonsterSpriteCell!
				switch selectedRowIndex {
				case monsterCellNumber.FirstCell:
					cell = firstMonster
				case monsterCellNumber.SecondCell:
					cell = secondMonster
				case monsterCellNumber.ThirdCell:
					cell = thirdMonster
				case monsterCellNumber.FourthCell:
					cell = fourthMonster
				case monsterCellNumber.FifthCell:
					cell = fifthMonster
				case monsterCellNumber.SixthCell:
					cell = sixthMonster
				}
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



