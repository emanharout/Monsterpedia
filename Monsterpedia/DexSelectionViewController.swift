//
//  UIViewController.swift
//  Monsterpedia
//
//  Created by Emmanuoel Haroutunian on 1/2/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class DexSelectionViewController: UIViewController {
  
  @IBOutlet var dexSelectionButtons: [UIDexButton]!
  var delegate: DexSelectionViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func selectDex(_ sender: UIButton) {
    switch sender.tag {
    case 0:
      delegate?.userDidSelect(Dex.kanto)
    case 1:
      delegate?.userDidSelect(Dex.johto)
    case 2:
      delegate?.userDidSelect(Dex.hoenn)
    case 3:
      delegate?.userDidSelect(Dex.sinnoh)
    case 4:
      delegate?.userDidSelect(Dex.unova)
    case 5:
      delegate?.userDidSelect(Dex.kalos)
    default:
      print("Error sending Dex to DexSelectionViewController's delegate")
    }
  }
}

protocol DexSelectionViewControllerDelegate {
  func userDidSelect(_ dex: Dex)
}
