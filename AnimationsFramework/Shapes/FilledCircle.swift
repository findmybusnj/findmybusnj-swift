//
//  FilledCircle.swift
//  findmybusnj
//
//  Created by David Aghassi on 1/17/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import Foundation
import UIKit

class FilledCircle: Circle {
    
    override init(frame: CGRect, color: CGColor) {
        super.init(frame: frame, color: color)
        
        circle.fillColor = color
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
