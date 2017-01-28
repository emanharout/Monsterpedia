//
//  UIImageView+DynamicHeight.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 1/27/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

extension UIImageView {
  func adjust(vertical constraint: NSLayoutConstraint, toFit image: UIImage) {
    let imageViewWidth = self.frame.width
    let imageWidth = image.size.width
    let imageHeight = image.size.height
    let scaleRatio = imageViewWidth / imageWidth
    
    
    let adjustedConstraintConstant = scaleRatio * imageHeight
    print("Constant: \(adjustedConstraintConstant)")
    constraint.constant = adjustedConstraintConstant
  }
}
