//
//  TodayViewController.swift
//  Find My Bus NJ Today Widget
//
//  Created by David Aghassi on 4/6/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController {
  // MARK: Outlets
  @IBOutlet weak var stopLabel: UILabel!
  @IBOutlet weak var routeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view from its nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

extension TodayViewController: NCWidgetProviding {
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    completionHandler(NCUpdateResult.NewData)
  }
  
}
