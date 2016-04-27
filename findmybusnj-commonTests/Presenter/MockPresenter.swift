//
//  MockPresenter.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/23/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit

// Dependencies
import findmybusnj_common
import SwiftyJSON

class MockPresenter: ETAPresenter {
  var sanitizer = JSONSanitizer()
  
  func formatCellForPresentation(cell: UITableViewCell, json: JSON) {
    
  }
  func assignArrivalTimeForJson(cell: UITableViewCell, json: JSON) {
    
  }
  func assignBusAndRouteTextForJson(cell: UITableViewCell, json: JSON) {
    
  }
}
