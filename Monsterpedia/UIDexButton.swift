//
//  UIDexButton.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 1/24/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class UIDexButton: UIButton {
  
  override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        backgroundColor = UIColor.lightGray
      } else {
        backgroundColor = UIColor.white
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    setupLayer()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setupLayer()
  }
  
  func setupLayer() {
    layer.cornerRadius = 10
    
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize.zero
    layer.shadowOpacity = 0.5
    layer.shadowRadius = 2.0
    
    layer.masksToBounds = false
  }

}
