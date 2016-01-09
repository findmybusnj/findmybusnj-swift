//
//  ETACard.swift
//  findmybusnj
//
//  Created by David Aghassi on 10/20/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import UIKit
import AnimationsFramework

class ETACard: UITableViewCell {
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var busNumberLabel: UILabel!   // Contains 'Bus:'
    @IBOutlet weak var routeLabel: UILabel! // Contains 'Via:'
    @IBOutlet weak var circleView: UIView!  // Contains the timing circle
    @IBOutlet weak var timeLabel: UILabel!  // Contains the arrival time
    
    override func layoutSubviews() {
        cardSetup()
        self.addSubview(card)
    }
    
    func cardSetup() {
        self.card.alpha = 1
        self.card.layer.masksToBounds = false
        self.card.layer.cornerRadius = 1
        self.card.layer.shadowOffset = CGSizeMake(-0.2, 0.2)
        self.card.layer.shadowRadius = 1
        
        let path = UIBezierPath(rect: self.card.bounds)
        self.card.layer.shadowPath = path.CGPath
        
        self.card.layer.shadowOpacity = 0.2
    }
    
    func renderCircleForBusTime(busTime: Int) {
        ShapeRenderer.renderCircleForBusTime(circleView, busTime: busTime)
    }
    
    func removeCircleFromCard(view: UIView) {
        ShapeRenderer.removeRenderedCircle(view);
    }
}