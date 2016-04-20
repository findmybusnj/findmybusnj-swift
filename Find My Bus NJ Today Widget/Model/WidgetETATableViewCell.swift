//
//  WidgetETATableViewCell.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/19/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit

class WidgetETATableViewCell: UITableViewCell {

  // MARK: Outlets
  @IBOutlet weak var routeLabel: UILabel!
  @IBOutlet weak var routeDescriptionLabel: UILabel!
  @IBOutlet weak var etaView: UIView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
}
