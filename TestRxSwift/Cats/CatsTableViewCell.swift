//
//  CatsTableViewCell.swift
//  TestRxSwift
//
//  Created by Admin on 14/04/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CatsTableViewCell: UITableViewCell {
  @IBOutlet private weak var factLabel: UILabel!
  
  func configuration(model: CatFactModel) {
    self.factLabel.text = model.text
  }
}
