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
    public static func renderCircleForBusTime(view: UIView, busTime: Int) {
        let circle = Circle(frame: view.layer.frame)
        
        // Draw the circle in the view at the top left origin
        circle.addCircleToView(view, xCoordinate: view.frame.origin.x, busTimeForBorderLength: busTime)
    }
}