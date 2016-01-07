//
//  Circle.swift
//  findmybusnj
//
//  The following was adapted from http://stackoverflow.com/questions/26578023/animate-drawing-of-a-circle
//
//  Created by David Aghassi on 11/29/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import UIKit

class Circle: UIView {
    var circle: CAShapeLayer!
    
    init(frame: CGRect, color: CGColor) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clearColor()
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: (frame.size.width - 10) / 2.0, y: (frame.size.height + 10) / 2.0), radius: (frame.size.width)/2, startAngle: -1.57, endAngle: CGFloat(M_PI * 2.0), clockwise: true)

        // Set the properties on the circle
        circle = CAShapeLayer()
        circle.path = circlePath.CGPath
        circle.fillColor = UIColor.clearColor().CGColor
        circle.strokeColor = color
        circle.lineWidth = 8.0
        
        // Wait to draw the circle
        circle.strokeEnd = 0.0
        
        layer.addSublayer(circle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    * Used to animate the drawing of the circle
    *
    * @param duration: Takes an NSTimeInterval to denote how long it should take
    * to draw the circle
    * @param borderLength: how far around the circle should travel. If more than
    * 1 it will be set to one (hence it is variable and not let)
    **/
    func animateCircle(duration: NSTimeInterval, var borderLength: CGFloat) {
        if (borderLength > 1) {
            borderLength = 1
        }
        
        // We want to animate the stokeEnd property of the circle layer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the duration
        animation.duration = duration
        
        // Animate circle from top of the circle to define length
        animation.fromValue = 0
        animation.toValue  = borderLength
        
        // Constant speed while drawing the circle
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circle layer so it is the right size when it ends
        circle.strokeEnd = borderLength
        
        // Do the actual animation
        circle.addAnimation(animation, forKey: "animateCircle")
    }
    
    /**
    * Adds a circle to the given view controller, will draw based on time passed in
    *
    * @param view   The view to be added to
    * @param xCoordinates   Where in the view to the top left of the circle should be placed
    * @param busTimeForBorderLength   Denotes the bus time that will determine how far the circle goes
    **/
    func addCircleToView(view: UIView, xCoordinate: CGFloat, busTimeForBorderLength: Int) {
        self.tag = 4    //  4 Stands for the item it should be (which in this case is the last) so we can remove it
        view.addSubview(self)
        
        // Animate the drawing of the circle over the course of 1 second
        let borderLength = calculateBorderLengthForBusTime(busTimeForBorderLength)
        self.animateCircle(1.0, borderLength: borderLength)       // Border length should change when we have a time in the future
    }
    
    /**
    * Given a bus time, this will decide how long the border length should be
    * 
    * @param busTime    The time, as an int, that will determine the border lenght
    * @return   A CGFloat between 0 and 1 that reperesents the border length
    **/
    private func calculateBorderLengthForBusTime(busTime: Int) -> CGFloat {
        let time = (Float(busTime))/35.0    // 35 is a magic number that allows 
                                            // the circle to be broken up into sections of 8ths
                                            // so long as we never get higher than 35 minutes
        return CGFloat(time)
    }
}