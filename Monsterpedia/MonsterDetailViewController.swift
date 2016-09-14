//
//  MonsterDetailViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 9/12/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class MonsterDetailViewController: UIViewController {
	
	@IBOutlet weak var navItem: UINavigationItem!
	@IBOutlet weak var monsterImage: UIImageView!
	@IBOutlet weak var monsterNameLabel: UILabel!
	@IBOutlet weak var heightLabel: UILabel!
	@IBOutlet weak var widthLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	@IBOutlet weak var pediaEntry: UILabel!
	let pokeClient = PokeAPIClient.sharedInstance
	
	var selectedMonster: Monster!

    override func viewDidLoad() {
        super.viewDidLoad()

		navItem.title = selectedMonster.name
		// Retrieve data
		// Store data into appropriate outlets
		pokeClient.getPokemonData(selectedMonster) { (result, error) in
			guard error == nil else {
				print(error)
				return
			}
			
			if let error = error {
				print("Error exists")
			} else {
				print("Error is nil")
			}
			
			if let result = result {
				print(result)
			} else {
				print("Result is nil")
			}
			
			guard let resultDict = result as? [String: AnyObject] else {
				print("Could not retrieve top-level dict from JSON results")
				return
			}
			print(resultDict)
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
		
    }

}
