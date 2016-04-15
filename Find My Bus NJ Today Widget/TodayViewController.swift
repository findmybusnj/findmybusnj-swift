//
//  TodayViewController.swift
//  Find My Bus NJ Today Widget
//
//  Created by David Aghassi on 4/6/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit
import NotificationCenter

// Dependencies
import SwiftyJSON
import NetworkManager

class TodayViewController: UIViewController {
  // MARK: Properties
  private var items: JSON = []
  private var stop = "", route = ""
  private let networkManager = NMServerManager()
  
  // MARK: Outlets
  @IBOutlet weak var stopLabel: UILabel!
  @IBOutlet weak var routeLabel: UILabel!
  @IBOutlet weak var etaTableView: UITableView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Fade in without retaining self
    view.alpha = 0
    UIView.animateWithDuration(0.4) { [unowned self] in
      self.view.alpha = 1
    }
    
    loadFromAppGroup()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view from its nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  /**
   Loads the most recent `stop` and `route` from the shared AppGroup
   */
  private func loadFromAppGroup() {
    if let appGroup = NSUserDefaults.init(suiteName: "group.aghassi.TodayExtensionSharingDefaults") {
      guard let currentStop = appGroup.objectForKey("currentStop") as? String else {
        return
      }
      stop = currentStop
      stopLabel.text = stop
      
      if let selectedStop = appGroup.objectForKey("filterRoute") as? String {
        route = selectedStop
      }
      else {
        route = ""
      }
      routeLabel.text = route
    }
  }
}

// MARK: NCWidgetProviding
extension TodayViewController: NCWidgetProviding {
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    completionHandler(NCUpdateResult.NewData)
  }
  
}

// MARK: UITableViewDataSource
extension TodayViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let identifier = "etaCell"
    let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
    return cell
  }
}

// MARK: UITableViewDelegate
extension TodayViewController: UITableViewDelegate {
  
}
