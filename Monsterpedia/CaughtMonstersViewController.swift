
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
	var fetchRequest: NSFetchRequest!
	var monsters = [Monster]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupFlowLayout()
		// TODO: Set Status Bar Style
		
		fetchRequest = NSFetchRequest(entityName: "Monster")
		let sortDesc = NSSortDescriptor(key: "id", ascending: true)
		fetchRequest.sortDescriptors = [sortDesc]
		
		do {
			monsters = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [Monster]
		} catch let error as NSError {
			print(error)
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		setupCollectionView()
	}
}


// MARK: CollectionView Delegate Functions
extension CaughtMonstersViewController: UICollectionViewDelegate, UICollectionViewDataSource, CollectionHeaderViewDelegate {
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return monsters.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MonsterCell", forIndexPath: indexPath) as! MonsterCell
		let monster = monsters[indexPath.row]
		cell.nameLabel.text = monster.name
		cell.imageView.image = UIImage(named: monster.image2DName)
		
		if monster.isCaught {
			cell.imageView.alpha = 1.0
		} else {
			cell.imageView.alpha = 0.4
		}
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MonsterCell
		let monster = monsters[indexPath.row]
		
		if monster.isCaught {
			cell.imageView.alpha = 0.40
			monster.isCaught = false
		} else {
			cell.imageView.alpha = 1.0
			monster.isCaught = true
		}
	}
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CollectionHeaderView", forIndexPath: indexPath) as! CollectionHeaderView
		headerView.delegate = self
		return headerView
	}
	
	
	// MARK: CollectionView Functions
	func setupFlowLayout() {
		
		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 12.0)
		
		let itemWidthDimension = ((view.frame.size.width - 36.0)/3)
		let itemHeightDimension = itemWidthDimension + 10.0
		flowLayout.minimumLineSpacing = CGFloat(20.0)
		flowLayout.minimumInteritemSpacing = CGFloat(6.0)
		flowLayout.itemSize = CGSize(width: itemWidthDimension, height: itemHeightDimension)
	}
	
	func didSelectSegment(sender: CollectionHeaderView, selectedSegmentIndex: Int) {
		let predicate: NSPredicate!
		switch selectedSegmentIndex {
		case 0:
			predicate = nil
			fetchRequest.predicate = predicate
		case 1:
			predicate = NSPredicate(format: "isCaught == %@", true)
			fetchRequest.predicate = predicate
		case 2:
			predicate = NSPredicate(format: "isCaught == %@", false)
			fetchRequest.predicate = predicate
		default: break
		}
		
		do {
			monsters = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [Monster]
			collectionView.reloadData()
		} catch let error as NSError {
			print(error)
		}
	}
	
	func setupCollectionView() {
		collectionView.alwaysBounceVertical = true
		let verticalOffsetValue = CGFloat(66)
		collectionView.contentOffset = CGPointMake(0, verticalOffsetValue)
	}
}




