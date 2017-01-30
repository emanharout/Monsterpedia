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
	@IBOutlet weak var monsterImageView: UIImageView!
	@IBOutlet weak var monsterNameLabel: UILabel!
	@IBOutlet weak var heightLabel: UILabel!
	@IBOutlet weak var weightLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	@IBOutlet weak var pediaEntry: UILabel!
	@IBOutlet weak var initialLoadActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var pediaEntryActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var monsterImageViewHeightConstraint: NSLayoutConstraint!
  
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
    pokeClient.getMonsterHeaderJSON(for: selectedMonster) { (result, error) in
			guard error == nil else {
        self.createAndPresentErrorAlert(with: error!.localizedDescription)
        group.leave()
        return
			}
      let monsterHeaderInfo = self.parse(monsterHeaderJSON: result)
      if let height = monsterHeaderInfo.height, let weight = monsterHeaderInfo.weight, let types = monsterHeaderInfo.types {
        monsterHeight = height
        monsterWeight = weight
        monsterTypes = types
      }
			group.leave()
		}
		
		group.enter()
		pokeClient.getFlavorTextJSON(for: selectedMonster, dex: .kanto) { (result, error) in
      guard error == nil else {
        self.createAndPresentErrorAlert(with: error!.localizedDescription)
        group.leave()
        return
      }
      
      let flavorText = self.parse(flavorTextJSON: result, dex: Dex.kanto)
      if let flavorText = flavorText {
        monsterFlavorText = flavorText
      }
      group.leave()
		}
		
		group.notify(queue: .main) {
      self.displayUIWithRetrievedValues(monsterHeight, monsterWeight, monsterTypes, monsterFlavorText)
		}
	}
  
  func parse(monsterHeaderJSON: AnyObject?) -> (height: Int?, weight: Int?, types: [String]?)  {
    guard let monsterHeaderJSON = monsterHeaderJSON as? [String: AnyObject] else {
      return (height: nil, weight: nil, types: nil)
    }
    guard let height = monsterHeaderJSON["height"] as? Int, let weight = monsterHeaderJSON["weight"] as? Int, let typeArray = monsterHeaderJSON["types"] as?[[String: AnyObject]] else {
      self.createAndPresentErrorAlert(with: "Failed to retrieve results monster stats")
      return (height: nil, weight: nil, types: nil)
    }
    
    var monsterTypes = [String]()
    for typeDict in typeArray {
      guard let type = typeDict["type"] as? [String: AnyObject], let typeName = type["name"] as? String else {
        print("Could not retrieve type name")
        return (height: nil, weight: nil, types: nil)
      }
      monsterTypes.append(typeName)
    }
    return (height: height, weight: weight, types: monsterTypes)
  }
  
  func parse(flavorTextJSON: AnyObject?, dex: Dex) -> String? {
    guard let flavorTextJSON = flavorTextJSON as? [String: AnyObject], let flavorTextArrays = flavorTextJSON["flavor_text_entries"] as? [[String: AnyObject]] else {
      print("Could not retrieve monster's flavor text")
      return nil
    }
    
    for flavorTextEntry in flavorTextArrays {
      guard let language = flavorTextEntry["language"] as? [String: AnyObject], let languageName = language["name"] as? String else {
        print("Could not retrieve language name")
        return nil
      }
      guard let gameVersion = flavorTextEntry["version"] as? [String: AnyObject], let gameVersionName = gameVersion["name"] as? String else {
        print("Could not retrieve game version name")
        return nil
      }
      
      if languageName == "en" && gameVersionName == dex.rawValue {
        guard let flavorText = flavorTextEntry["flavor_text"] as? String else {
          print("Could not retrieve flavor text")
          return nil
        }
        return flavorText
      }
    }
    return nil
  }
  
  func displayUIWithRetrievedValues(_ monsterHeight: Int, _ monsterWeight: Int, _ monsterTypes: [String], _ monsterFlavorText: String) {
    monsterNameLabel.text = selectedMonster.name
    if let monsterImage = UIImage(named: selectedMonster.image2DName) {
      monsterImageView.image = monsterImage
      monsterImageView.adjust(vertical: self.monsterImageViewHeightConstraint, toFit: monsterImage)
    }
    heightLabel.text = "Height: \(monsterHeight)"
    weightLabel.text = "Weight: \(monsterWeight)"
    
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

  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "embedDexSelectionViewController" {
      guard let dexSelectionViewController = segue.destination as? DexSelectionViewController else {
        print("Could not cast destinationVC to DexSelectionVC")
        return
      }
      dexSelectionViewController.delegate = self
    }
  }

  func createAndPresentErrorAlert(with message: String) {
    let mainQueue = DispatchQueue.main
    mainQueue.async {
      let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(action)
      self.present(alert, animated: true, completion: nil)
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
      
      if let flavorText = self.parse(flavorTextJSON: result, dex: dex) {
        DispatchQueue.main.async {
          self.stopLoadingAnimation()
          self.pediaEntry.text =  flavorText.replacingOccurrences(of: "\\s", with: " ", options: .regularExpression)
        }
      }
    }
  }
  
  func stopLoadingAnimation() {
    let mainQueue = DispatchQueue.main
    mainQueue.async {
      self.pediaEntryActivityIndicator.stopAnimating()
      // UILabel goes from alpha 0 to 1 when animation stops
      self.pediaEntry.textColor = UIColor(red: 240/255, green: 11/255, blue: 49/255, alpha: 1)
    }
  }
}
