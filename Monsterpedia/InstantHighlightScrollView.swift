//
//  instantHighlightScrollView.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 1/24/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit
/// Subclass allows for UIDexButtons to instantly highlight upon tap *while* also being responsive to drags in order to scroll
class InstantHighlightScrollView: UIScrollView {

  override func touchesShouldCancel(in view: UIView) -> Bool {
    if view is UIButton {
      return  true
    }
    return  super.touchesShouldCancel(in: view)
  }

}
