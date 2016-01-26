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
}
