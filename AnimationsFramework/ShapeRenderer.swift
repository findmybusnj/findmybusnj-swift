//
//  ShapeRenderer.swift
//  findmybusnj
//
//  Created by David Aghassi on 11/29/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import UIKit

public class ShapeRenderer {
    // Stroke color of the circle to be rendered
    private static var strokeColor: CGColor!
    
    /**
    * Creates a circle and renders it given the current bus time
    * The circle is added to the subview afterward
    *
    * @param view   The view the circle will be added to
    * @param busTime    Time of the next arriving bus as an int
    **/
    public static func renderCircleForBusTime(view: UIView, busTime: Int) {
        determineStrokeColorForBusTime(busTime)
        
        let circleWidth = CGFloat(view.frame.width)
        let circleHeight = circleWidth
        let circle = Circle(frame: CGRectMake(view.frame.origin.x, 0, circleWidth, circleHeight), color: strokeColor)
        
        // Draw the circle in the view at the top left origin
        circle.addCircleToView(view, xCoordinate: view.frame.origin.x, busTimeForBorderLength: busTime)
    }
    
    /**
    * Removes the object with tag 4, which is assumed to be the circle, from the given view
    *
    * @param view   The view to remove the circle from
    **/
    public static func removeRenderedCircle(view: UIView) {
        view.viewWithTag(4)?.removeFromSuperview()  // Remove the prior circle if it exists
    }
    
    /**
     * Sets the stroke color of the circle based on the bus time being passed in
     *
     * @param busTime    The time the bus will be arriving as an int
     **/
    private static func determineStrokeColorForBusTime(busTime: Int) {
        if (busTime <= 7) {
            // Green
            self.strokeColor = UIColor(colorLiteralRed: Float(29/255.0), green: Float(156/255.0), blue: Float(48/255.0), alpha: Float(1.0)).CGColor
        }
        else if ( busTime <= 14) {
            // Orange
            self.strokeColor = UIColor(colorLiteralRed: Float(237/255.0), green: Float(145/255.0), blue: Float(50/255.0), alpha: Float(1.0)).CGColor
        }
        else {
            // Red
            self.strokeColor = UIColor(colorLiteralRed: Float(204/255.0), green: Float(25/255.0), blue: Float(36/255.0), alpha: Float(1.0)).CGColor
        }
    }
}