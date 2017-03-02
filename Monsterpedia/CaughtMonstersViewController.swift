
//
//  CaughtMonstersViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 8/23/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit
import CoreData

class CaughtMonstersViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
  
  var coreDataStack: CoreDataStack!
  var fetchRequest: NSFetchRequest<Monster>!
  var monsters = [Monster]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    
    fetchRequest = NSFetchRequest(entityName: "Monster")
    let sortDesc = NSSortDescriptor(key: "id", ascending: true)
    fetchRequest.sortDescriptors = [sortDesc]
    do {
      monsters = try coreDataStack.context.fetch(fetchRequest)
    } catch let error as NSError {
      print(error)
    }
  }
}


// MARK: CollectionView Delegate Functions
extension CaughtMonstersViewController: UICollectionViewDelegate, UICollectionViewDataSource, CollectionHeaderViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return monsters.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonsterCell", for: indexPath) as! MonsterCell
    let monster = monsters[indexPath.row]
    cell.nameLabel.text = monster.name
    cell.imageView.image = UIImage(named: monster.image2DName)
    
    if monster.isCaught {
      cell.alpha = 1.0
    } else {
      cell.alpha = 0.40
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! MonsterCell
    let monster = monsters[(indexPath as NSIndexPath).row]
    
    if monster.isCaught {
      cell.alpha = 0.4
      monster.isCaught = false
    } else {
      cell.alpha = 1.0
      monster.isCaught = true
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeaderView", for: indexPath) as! CollectionHeaderView
    headerView.delegate = self
    return headerView
  }
  
  
  // MARK: CollectionView Functions
  func setupViews() {
    
    // Setup flowLayout
    flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 12.0)
    
    let itemWidthDimension = ((view.frame.size.width - 36.0)/3)
    let itemHeightDimension = itemWidthDimension + 10.0
    flowLayout.minimumLineSpacing = CGFloat(20.0)
    flowLayout.minimumInteritemSpacing = CGFloat(6.0)
    flowLayout.itemSize = CGSize(width: itemWidthDimension, height: itemHeightDimension)
    
    // Setup collectionView
    collectionView.alwaysBounceVertical = true
  }
  
  func didSelectSegment(_ sender: CollectionHeaderView, selectedSegmentIndex: Int) {
    let predicate: NSPredicate!
    switch selectedSegmentIndex {
    case 0:
      predicate = nil
      fetchRequest.predicate = predicate
    case 1:
      predicate = NSPredicate(format: "isCaught == %@", true as CVarArg)
      fetchRequest.predicate = predicate
    case 2:
      predicate = NSPredicate(format: "isCaught == %@", false as CVarArg)
      fetchRequest.predicate = predicate
    default: break
    }
    
    do {
      monsters = try coreDataStack.context.fetch(fetchRequest)
      collectionView.reloadData()
    } catch let error as NSError {
      print(error)
    }
  }
}




