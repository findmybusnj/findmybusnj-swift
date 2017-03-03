//
//  ETACard.swift
//  findmybusnj
//
//  Created by David Aghassi on 10/20/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import UIKit

// MARK: Dependancies
import AnimationsFramework

class ETACard: UITableViewCell {

  // MARK: Outlets
  @IBOutlet weak var card: UIView!
  @IBOutlet weak var busNumberLabel: UILabel!   // Contains `Bus:` label
  @IBOutlet weak var routeLabel: UILabel! // Contains `Via:` label
  @IBOutlet weak var circleView: UIView!  // Contains the timing circle
  @IBOutlet weak var timeLabel: UILabel!  // Contains the arrival time in the cirlce
  @IBOutlet weak var noPrediction: UILabel! // Hidden label that shows when there is no prediction

  override func layoutSubviews() {
    cardSetup()
    self.addSubview(card)
  }

  /**
   This will setup the custom card that will be used for the `tableView`
   
   This card was taken from 
   [iOS - A Card Based Newsfeed](https://medium.com/@cwRichardKim/ios-xcode-tutorial-a-card-based-newsfeed-8bedeb7b8df7#.orv4whtyi)
   */
  func cardSetup() {
    self.card.alpha = 1
    self.card.layer.masksToBounds = false
    self.card.layer.cornerRadius = 1
    self.card.layer.shadowOffset = CGSize(width: -0.2, height: 0.2)
    self.card.layer.shadowRadius = 1

    let path = UIBezierPath(rect: self.card.bounds)
    self.card.layer.shadowPath = path.cgPath

    self.card.layer.shadowOpacity = 0.2
  }

  /**
   Renders a circle in the `circleView` given a bus time that we get from our `.POST` request
   in the `BustimeTableController`. See `AFShapeRenderer.swift` for more info
   
   - Parameter busTime: The integer time that will be used to denote the circumference of the circle
   */
  func renderCircleForBusTime(_ busTime: Int) {
    AFShapeRenderer.renderCircleForBusTime(circleView, busTime: busTime)
  }

  /**
   Renders a filled circle to the `circleView` given a bus time that we get from `.POST` request
   
   - Parameter: bustime: The integer time that will be used to render the circumference of the circle
   */

  func renderFilledCircleForBusTime(_ busTime: Int) {
    AFShapeRenderer.renderFilledCircleForBusTime(circleView, busTime: busTime)
  }

  /**
   Removes circle from the given view
   
   - Parameter view: The view to remove the circle from
   */
  func removeCircleFromCard(_ view: UIView) {
    AFShapeRenderer.removeRenderedCircle(view)
  }

  /**
   Clears all the texts in the subviews and hides the "No Prediction" label
   */
  func clearText() {
    busNumberLabel.text = ""
    routeLabel.text = ""
    timeLabel.text = ""
    noPrediction.isHidden = true
  }

}
