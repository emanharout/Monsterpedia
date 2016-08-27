//
//  CollectionHeaderView.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 7/30/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	@IBAction func blabla (sender: AnyObject) {
		delegate?.didTapButton(self)
	}
	
	var delegate: CollectionHeaderViewDelegate?
	
}

protocol CollectionHeaderViewDelegate {
	func didTapButton(sender: CollectionHeaderView)
}


