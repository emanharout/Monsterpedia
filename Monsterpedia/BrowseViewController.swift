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
		
//		dispatch_async(dispatch_get_main_queue()) {
//			self.collectionView.contentOffset = CGPointMake(0, 100)
//			print(self.flowLayout.headerReferenceSize)
//		}
		//collectionView.contentOffset.y = 100
		//collectionView.contentInset = UIEdgeInsets(top: -50, left: 0, bottom: 0, right: 0)
//		collectionView.setContentOffset(CGPointMake(0, 90.0), animated: true)
//		collectionView.alwaysBounceVertical = true
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let yPoint = flowLayout.headerReferenceSize.height
		collectionView.contentOffset = CGPointMake(0, yPoint - 20.0)
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
		// view width < collectionView width, so we use view width as its smaller
		// 20 * 2 subtracted in itemWidthDimension for view margins on either side
		
		let itemWidthDimension = ((view.frame.size.width - 72.0)/3)
		print("item width: \(itemWidthDimension)")
		let itemHeightDimension = itemWidthDimension + 26.0
		
		flowLayout.minimumLineSpacing = CGFloat(20.0)
		flowLayout.minimumInteritemSpacing = CGFloat(16.0)
		flowLayout.itemSize = CGSize(width: itemWidthDimension, height: itemHeightDimension)
		print("flowlayout item size: \(flowLayout.itemSize)")
	}
	
	
}