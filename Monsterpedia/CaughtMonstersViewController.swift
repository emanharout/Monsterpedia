//
//  CaughtMonstersViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 8/23/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class CaughtMonstersViewController: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
	
	var monsters: [String]!


    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupFlowLayout()
		collectionView.alwaysBounceVertical = true
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let yPoint = flowLayout.headerReferenceSize.height
		collectionView.contentOffset = CGPointMake(0, yPoint - 20.0)
	}
}


	
extension CaughtMonstersViewController: UICollectionViewDelegate, UICollectionViewDataSource, CollectionHeaderViewDelegate {
		
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
		let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CollectionHeaderView", forIndexPath: indexPath) as! CollectionHeaderView
		headerView.delegate = self
		return headerView
	}
	
	// MARK: CollectionView Functions
	
	func setupFlowLayout() {
		
		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 12.0)
		
		let itemWidthDimension = ((view.frame.size.width - 36.0)/3)
		let itemHeightDimension = itemWidthDimension + 40.0
		flowLayout.minimumLineSpacing = CGFloat(20.0)
		flowLayout.minimumInteritemSpacing = CGFloat(6.0)
		flowLayout.itemSize = CGSize(width: itemWidthDimension, height: itemHeightDimension)
	}
	
	func didTapButton(sender: CollectionHeaderView) {
		print("Delegate's Button Tapped")
	}
}
	



