//
//  ViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 7/30/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var segmentController: UISegmentedControl!
	
	var monsters: [String]!
	

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupFlowLayout()
		collectionView.alwaysBounceVertical = true
		
		print(monsters)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let yPoint = flowLayout.headerReferenceSize.height
		collectionView.contentOffset = CGPointMake(0, yPoint - 20.0)
		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
		//collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}



extension BrowseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	// MARK: CollectionView Delegate Functions
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return monsters.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MonsterCell", forIndexPath: indexPath) as! MonsterCell
		cell.nameLabel.text = monsters[indexPath.row]
		cell.imageView.image = UIImage(named: monsters[indexPath.row])
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CollectionHeaderView", forIndexPath: indexPath) as! CollectionHeaderView
		return view
	}
	
	
	
	// MARK: CollectionView Functions
	func setupFlowLayout() {
		
		print("view width: \(view.frame.width)")
		print("collectionView width: \(collectionView.frame.size.width)")
		
		let itemWidthDimension = ((view.frame.size.width - 72.0)/3)
		print("item width: \(itemWidthDimension)")
		let itemHeightDimension = itemWidthDimension + 26.0
		
		flowLayout.minimumLineSpacing = CGFloat(20.0)
		flowLayout.minimumInteritemSpacing = CGFloat(16.0)
		flowLayout.itemSize = CGSize(width: itemWidthDimension, height: itemHeightDimension)
		print("flowlayout item size: \(flowLayout.itemSize)")
		
		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
	}
	
	
}