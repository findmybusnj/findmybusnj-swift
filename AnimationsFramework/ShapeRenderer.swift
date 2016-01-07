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
        let circle = Circle(frame: view.layer.frame, color: strokeColor)
        
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
            self.strokeColor = UIColor.greenColor().CGColor
        }
        else if ( busTime <= 14) {
            self.strokeColor = UIColor.yellowColor().CGColor
        }
        else {
            self.strokeColor = UIColor.redColor().CGColor
        }
    }
}