//
//  FilledCircle.swift
//  findmybusnj
//
//  Created by David Aghassi on 1/17/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import Foundation
import UIKit

/**
 A class that will render a circle that has a filled color
 */
class FilledCircle: Circle {
  
  /**
   Creates a `Circle` object and then sets the `fillColor` to the color of the stroke color
   */
  override init(frame: CGRect, color: CGColor) {
    super.init(frame: frame, color: color)
    
    circle.fillColor = color
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /**
   Adds a circle to the given view controller, will draw based on time passed in
   
   - Parameters:
   - view: The view to be added to
   - xCoordinates: Where in the view to the top left of the circle should be placed
   - busTimeForBorderLength: Denotes the bus time that will determine how far the circle goes
   */
  func addFilledCircleToView(_ view: UIView, xCoordinate: CGFloat) {
    self.tag = 4    //  4 Stands for the item it should be (which in this case is the last) so we can remove it
    view.addSubview(self)
    view.sendSubview(toBack: self)
    
    self.animateCircle(1.0, borderLength: 0)       // Border length should change when we have a time in the future
  }
}
