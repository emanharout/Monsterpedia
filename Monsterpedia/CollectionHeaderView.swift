//
//  CollectionHeaderView.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 7/30/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
	
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	@IBAction func segmentSelected (sender: AnyObject) {
		delegate?.didSelectSegment(self, selectedSegmentIndex: segmentedControl.selectedSegmentIndex)
	}
	
	var delegate: CollectionHeaderViewDelegate?
	
}

protocol CollectionHeaderViewDelegate {
	func didSelectSegment(sender: CollectionHeaderView, selectedSegmentIndex: Int)
}


