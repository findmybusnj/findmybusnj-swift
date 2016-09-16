//
//  ShapeRenderer.swift
//  findmybusnj
//
//  Created by David Aghassi on 11/29/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import UIKit

// Dependecies
import findmybusnj_common

/**
 A class from the `AnimationsFramework` that will render shapes
 
 TODO: Refactor this so it isn't static.
 */
open class AFShapeRenderer {
  // Stroke color of the circle to be rendered
  fileprivate static var strokeColor: CGColor!
  fileprivate static let colorPallette = ColorPalette()
  
  /**
   Creates a circle and renders it given the current bus time
   The circle is added to the subview afterward
   
   - Parameters:
   - view:   The view the circle will be added to
   - busTime:    Time of the next arriving bus as an int
   */
  open static func renderCircleForBusTime(_ view: UIView, busTime: Int) {
    determineStrokeColorForBusTime(busTime)
    
    let circleWidth = CGFloat(view.frame.width)
    let circleHeight = circleWidth
    // view.frame.origin.x is where the circle will be rendered from
    let circle = Circle(frame: CGRect(x: view.frame.origin.x, y: 0, width: circleWidth, height: circleHeight), color: strokeColor)
    circle.layer.addSublayer(circle.circle)
    
    // Draw the circle in the view at the top left origin
    circle.addCircleToView(view, xCoordinate: view.frame.origin.x, busTimeForBorderLength: busTime)
  }
  
  /**
   Renders a filled cricle instead of a hollow circle
   
   - Parameters:
   - view:   The view the circle will be added to
   - busTime:    Time of the next arriving bus as an int
   */
  open static func renderFilledCircleForBusTime(_ view: UIView, busTime: Int) {
    determineStrokeColorForBusTime(busTime)
    
    let circleWidth = CGFloat(view.frame.width)
    let circleHeight = circleWidth
    // view.frame.origin.x is where the circle will be rendered from
    let circle = FilledCircle(frame: CGRect(x: view.frame.origin.x, y: 0, width: circleWidth, height: circleHeight), color: strokeColor)
    circle.layer.addSublayer(circle.circle)
    
    // Draw the circle in the view at the top left origin
    circle.addFilledCircleToView(view, xCoordinate: view.frame.origin.x)
  }
  
  /**
   Removes the object with tag 4, which is assumed to be the circle, from the given view. If the tag is nil we return out of the function.
   
   - parameter view:   The view to remove the circle from
   */
  open static func removeRenderedCircle(_ view: UIView) {
    guard let tag = view.viewWithTag(4) else {
      return
    }
    
    tag.removeFromSuperview()  // Remove the prior circle if it exists
  }
  
  /**
   Sets the stroke color of the circle based on the bus time being passed in
   
   TODO: Remove this method and replace with use of `ETAPresenter`. This function is deprecated.
   
   - parameter busTime:    The time the bus will be arriving as an int
   */
  fileprivate static func determineStrokeColorForBusTime(_ busTime: Int) {
    if (busTime == 0) {
      // Blue
      self.strokeColor = colorPallette.powderBlue().cgColor
    }
    else if (busTime <= 7) {
      // Green
      self.strokeColor = colorPallette.emeraldGreen().cgColor
    }
    else if ( busTime <= 14) {
      // Orange
      self.strokeColor = colorPallette.creamsicleOrange().cgColor
    }
    else {
      // Red
      self.strokeColor = colorPallette.lollipopRed().cgColor
    }
  }
}
