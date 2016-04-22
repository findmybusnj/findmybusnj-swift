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
public class AFShapeRenderer {
  // Stroke color of the circle to be rendered
  private static var strokeColor: CGColor!
  private static let colorPallette = ColorPallette()
  
  /**
   Creates a circle and renders it given the current bus time
   The circle is added to the subview afterward
   
   - Parameters:
   - view:   The view the circle will be added to
   - busTime:    Time of the next arriving bus as an int
   */
  public static func renderCircleForBusTime(view: UIView, busTime: Int) {
    determineStrokeColorForBusTime(busTime)
    
    let circleWidth = CGFloat(view.frame.width)
    let circleHeight = circleWidth
    // view.frame.origin.x is where the circle will be rendered from
    let circle = Circle(frame: CGRectMake(view.frame.origin.x, 0, circleWidth, circleHeight), color: strokeColor)
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
  public static func renderFilledCircleForBusTime(view: UIView, busTime: Int) {
    determineStrokeColorForBusTime(busTime)
    
    let circleWidth = CGFloat(view.frame.width)
    let circleHeight = circleWidth
    // view.frame.origin.x is where the circle will be rendered from
    let circle = FilledCircle(frame: CGRectMake(view.frame.origin.x, 0, circleWidth, circleHeight), color: strokeColor)
    circle.layer.addSublayer(circle.circle)
    
    // Draw the circle in the view at the top left origin
    circle.addFilledCircleToView(view, xCoordinate: view.frame.origin.x)
  }
  
  /**
   Removes the object with tag 4, which is assumed to be the circle, from the given view. If the tag is nil we return out of the function.
   
   - parameter view:   The view to remove the circle from
   */
  public static func removeRenderedCircle(view: UIView) {
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
  private static func determineStrokeColorForBusTime(busTime: Int) {
    if (busTime == 0) {
      // Blue
      self.strokeColor = colorPallette.powderBlue().CGColor
    }
    else if (busTime <= 7) {
      // Green
      self.strokeColor = colorPallette.emeraldGreen().CGColor
    }
    else if ( busTime <= 14) {
      // Orange
      self.strokeColor = colorPallette.creamsicleOrange().CGColor
    }
    else {
      // Red
      self.strokeColor = colorPallette.lollipopRed().CGColor
    }
  }
}