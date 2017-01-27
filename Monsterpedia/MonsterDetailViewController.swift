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
  @IBOutlet weak var dexContainerView: UIView!
	@IBOutlet weak var monsterImage: UIImageView!
	@IBOutlet weak var monsterNameLabel: UILabel!
	@IBOutlet weak var heightLabel: UILabel!
	@IBOutlet weak var weightLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	@IBOutlet weak var pediaEntry: UILabel!
	@IBOutlet weak var initialLoadActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var pediaEntryActivityIndicator: UIActivityIndicatorView!
	
	let pokeClient = PokeAPIClient.sharedInstance
	var selectedMonster: Monster!

  override func viewDidLoad() {
      super.viewDidLoad()

    navItem.title = selectedMonster.name
    pediaEntryActivityIndicator.stopAnimating()
    loadMonsterData(selectedMonster: selectedMonster)
  }
	
	func loadMonsterData(selectedMonster: Monster) {
		initialLoadActivityIndicator.startAnimating()
		
		let group = DispatchGroup()
		var monsterHeight = Int()
		var monsterWeight = Int()
		var monsterTypes = [String]()
		var monsterFlavorText = String()
		
		group.enter()
		pokeClient.getMonsterData(selectedMonster) { (result, error) in
			if let error = error {
				let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
				let action = UIAlertAction(title: "OK", style: .default, handler: nil)
				alert.addAction(action)
				self.present(alert, animated: true, completion: nil)
			} else if let result = result as? [String: AnyObject] {
				guard let height = result["height"] as? Int, let weight = result["weight"] as? Int else {
					let alert = UIAlertController(title: "Error", message: "Failed to retrieve results from server", preferredStyle: .alert)
					let action = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(action)
					self.present(alert, animated: true, completion: nil)
					group.leave()
					return
				}
				guard let typeArray = result["types"] as?[[String: AnyObject]] else {
					print("Could not retrieve typeArray")
					group.leave()
					return
				}
				
				for typeDict in typeArray {
					guard let type = typeDict["type"] as? [String: AnyObject], let typeName = type["name"] as? String else {
						print("Could not retrieve type name")
						group.leave()
						return
					}
					monsterTypes.append(typeName)
				}
				monsterHeight = height
				monsterWeight = weight
			}
			group.leave()
		}
		
		group.enter()
		pokeClient.getFlavorTextJSON(for: selectedMonster, dex: .kanto) { (result, error) in
			if let error = error {
				print(error)
			} else if let result = result as? [String: AnyObject] {
				guard let flavorTextArrays = result["flavor_text_entries"] as? [[String: AnyObject]] else {
					print("Could not retrieve monster's flavor text")
					group.leave()
					return
				}
				
        flavorTextLoop: for flavorTextEntry in flavorTextArrays {
					guard let language = flavorTextEntry["language"] as? [String: AnyObject], let languageName = language["name"] as? String else {
						print("Could not retrieve language name")
						group.leave()
						return
					}
          guard let gameVersion = flavorTextEntry["version"] as? [String: AnyObject], let gameVersionName = gameVersion["name"] as? String else {
            print("Could not retrieve game version name")
            group.leave()
            return
          }
          
					if languageName == "en" && gameVersionName == Dex.kanto.rawValue {
						guard let flavorText = flavorTextEntry["flavor_text"] as? String else {
							print("Could not retrieve flavor text")
							group.leave()
							return
						}
						monsterFlavorText = flavorText
						break flavorTextLoop
					}
				}
			}
			group.leave()
		}
		
		// Assign values to UI once data from both requests are downloaded
		group.notify(queue: .main) {
			self.monsterNameLabel.text = selectedMonster.name
			self.monsterImage.image = UIImage(named: selectedMonster.image2DName)
			self.heightLabel.text = "Height: \(monsterHeight)"
			self.weightLabel.text = "Weight: \(monsterWeight)"
			
			var type = "Type:"
			for typeName in monsterTypes {
				let formattedTypeName = typeName.capitalized
				type.append(" \(formattedTypeName),")
			}
			self.typeLabel.text = type.trimmingCharacters(in: CharacterSet.punctuationCharacters)
			// Removes line breaks from downloaded text
			self.pediaEntry.text = monsterFlavorText.replacingOccurrences(of: "\\s", with: " ", options: .regularExpression)
			
			self.monsterNameLabel.isHidden = false
			self.heightLabel.isHidden = false
			self.weightLabel.isHidden = false
			self.typeLabel.isHidden = false
      self.dexContainerView.isHidden = false
			
			self.initialLoadActivityIndicator.stopAnimating()
		}
	}
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "embedDexSelectionViewController" {
      guard let dexSelectionViewController = segue.destination as? DexSelectionViewController else {
        print("Could not cast destinationVC to DexSelectionVC")
        return
      }
      dexSelectionViewController.delegate = self
      
    }
  }
}

extension MonsterDetailViewController: DexSelectionViewControllerDelegate {
  func userDidSelect(_ dex: Dex) {
    self.pediaEntry.textColor = UIColor.clear
    self.pediaEntryActivityIndicator.startAnimating()
    pokeClient.getFlavorTextJSON(for: selectedMonster, dex: dex) { (result, error) in
      
      guard error == nil else {
        print(error!)
        self.stopLoadingAnimation()
        return
      }
      
      guard let result = result as? [String: AnyObject] else {
        self.stopLoadingAnimation()
        return
      }
      
      guard let flavorTextArrays = result["flavor_text_entries"] as? [[String: AnyObject]] else {
        print("Could not retrieve monster's flavor text")
        self.stopLoadingAnimation()
        return
      }
      
      flavorTextLoop: for flavorTextEntry in flavorTextArrays {
        guard let language = flavorTextEntry["language"] as? [String: AnyObject], let languageName = language["name"] as? String else {
          print("Could not retrieve language name")
          self.stopLoadingAnimation()
          return
        }
        guard let gameVersion = flavorTextEntry["version"] as? [String: AnyObject], let gameVersionName = gameVersion["name"] as? String else {
          print("Could not retrieve game version name")
          self.stopLoadingAnimation()
          return
        }
        
        if languageName == "en" && gameVersionName == dex.rawValue {
          guard let flavorText = flavorTextEntry["flavor_text"] as? String else {
            print("Could not retrieve flavor text")
            self.stopLoadingAnimation()
            return
          }
          
          DispatchQueue.main.async {
            self.pediaEntry.text =  flavorText.replacingOccurrences(of: "\\s", with: " ", options: .regularExpression)
          }
          self.stopLoadingAnimation()
          break flavorTextLoop
        }
      }
    }
  }
  
  func stopLoadingAnimation() {
    let mainQueue = DispatchQueue.main
    mainQueue.async {
      self.pediaEntryActivityIndicator.stopAnimating()
      self.pediaEntry.textColor = UIColor(red: 240/255, green: 11/255, blue: 49/255, alpha: 1)
    }
  }
}
