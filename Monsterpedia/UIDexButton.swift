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
      switch isHighlighted {
      case true:
        backgroundColor = UIColor.lightGray
      case false:
        backgroundColor = UIColor.clear
      }
    }
  }

}
