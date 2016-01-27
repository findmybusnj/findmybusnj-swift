//
//  ShapeRenderer.swift
//  findmybusnj
//
//  Created by David Aghassi on 11/29/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import UIKit

/**
 A class from the `AnimationsFramework` that will render shapes
 */
public class AFShapeRenderer {
  // Stroke color of the circle to be rendered
  private static var strokeColor: CGColor!
  
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
    circle.addCircleToView(view, xCoordinate: view.frame.origin.x, busTimeForBorderLength: busTime)
  }
  
  /**
   Removes the object with tag 4, which is assumed to be the circle, from the given view
   
   - parameter view:   The view to remove the circle from
   */
  public static func removeRenderedCircle(view: UIView) {
    view.viewWithTag(4)?.removeFromSuperview()  // Remove the prior circle if it exists
  }
  
  /**
   Sets the stroke color of the circle based on the bus time being passed in
   
   - TODO: Figure out how to make `Delay` not stroke red on the circumference
   
   - parameter busTime:    The time the bus will be arriving as an int
   */
  private static func determineStrokeColorForBusTime(busTime: Int) {
    if (busTime == 0) {
      // Blue
      self.strokeColor = UIColor(red: 67.0/255.0, green: 174.0/255.0, blue: 249.0/255.0, alpha: 1.0).CGColor
    }
    else if (busTime <= 7) {
      // Green
      self.strokeColor = UIColor(red: 29.0/255.0, green: 156.0/255.0, blue: 48.0/255.0, alpha: 1.0).CGColor
    }
    else if ( busTime <= 14) {
      // Orange
      self.strokeColor = UIColor(red: 237.0/255.0, green: 145.0/255.0, blue: 50.0/255.0, alpha: 1.0).CGColor
    }
    else {
      // Red
      self.strokeColor = UIColor(red: 204.0/255.0, green: 25.0/255.0, blue: 36.0/255.0, alpha: 1.0).CGColor
    }
  }
}