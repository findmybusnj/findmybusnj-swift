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
import findmybusnj_common

class TodayViewController: UIViewController {
  // MARK: Properties
  fileprivate var items: JSON = []
  fileprivate var stop = "", route = ""
  
  // MARK: Managers & Presenters
  fileprivate let networkManager = ServerManager()
  fileprivate let tableViewCellPresenter = WidgetETATableViewCellPresenter()
  fileprivate let sanatizer = JSONSanitizer()
  
  // MARK: Outlets
  @IBOutlet weak var stopLabel: UILabel!
  @IBOutlet weak var routeLabel: UILabel!
  @IBOutlet weak var etaTableView: UITableView!
  @IBOutlet weak var nextArrivingLabel: UILabel!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Fade in without retaining self
    view.alpha = 0
    UIView.animate(withDuration: 0.4, animations: { [unowned self] in
      self.view.alpha = 1
    }) 
    etaTableView.separatorColor = UIColor.clear
    etaTableView.tableFooterView = UIView(frame: CGRect.zero)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view from its nib.
    
    loadFromAppGroup()
    if #available(iOS 10.0, *) {
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    } else {
        // Fallback on earlier versions
    }
    
    if !route.isEmpty {
      networkManager.getJSONForStopFilteredByRoute(stop, route: route, completion: { [unowned self] (item, error) in
        // If error we don't change anything.
        if !item.isEmpty {
          self.updateTable(item)
        }
      })
    }
    else {
      networkManager.getJSONForStop(stop, completion: { [unowned self] (item, error) in
        // If error we don't change anything.
        if !item.isEmpty {
          self.updateTable(item)
        }
      })
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  /**
   Loads the most recent `stop` and `route` from the shared AppGroup
   */
  fileprivate func loadFromAppGroup() {
    if let appGroup = UserDefaults.init(suiteName: "group.aghassi.TodayExtensionSharingDefaults") {
      guard let currentStop = appGroup.object(forKey: "currentStop") as? String else {
        return
      }
      stop = currentStop
      stopLabel.text = stop
      
      if let selectedStop = appGroup.object(forKey: "filterRoute") as? String {
        route = selectedStop
      }
      else {
        route = ""
      }
      routeLabel.text = route
    }
  }
  
  /**
   Used as a callback to update the `tableView` with new data, if any.
   
   - parameter items: Items that will populate the `tableView`
   */
  fileprivate func updateTable(_ items: JSON) {
    let firstResponse = items.array?.first  // TODO: Find a better way to do this
    self.nextArrivingLabel.text = "The next bus will arrive in \(sanatizer.getSanitizedArrivaleTimeAsInt(firstResponse!)) minutes."
    self.items = items
    etaTableView.reloadData()
    
    // Let the system handle the resize
    guard #available(iOS 10.0, *) else {
        // If we are on iOS 9, do it ourself
        updateViewSize()
        return
    }
  }
  
  /**
   Updates the views `preferredContentSize` based on the height of the tableView
   */
  fileprivate func updateViewSize() {
    // Get the size and add a little so we don't cut off the button cell
    // Set the new size to the size of the widget
    let newHeight = etaTableView.contentSize.height + stopLabel.intrinsicContentSize.height + 75
    let constantWidth = etaTableView.contentSize.width
    let newPreferredContentSize = CGSize(width: constantWidth, height: newHeight)
    self.preferredContentSize = newPreferredContentSize
  }
  
  func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets.zero;
  }
  
  @available(iOS 10.0, *)
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
    if (activeDisplayMode == NCWidgetDisplayMode.compact) {
      self.preferredContentSize = maxSize
    }
    else {
      self.preferredContentSize = CGSize(width: maxSize.width, height: 400)
    }
  }
}

// MARK: NCWidgetProviding
extension TodayViewController: NCWidgetProviding {
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    completionHandler(NCUpdateResult.newData)
  }
  
}

// MARK: UITableViewDataSource
extension TodayViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let array = items.array {
        if array.count >  5 {
            return 5
        }
        else {
            return array.count
        }

    }
    else {
        return 0;
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = "arrivalCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WidgetETATableViewCell
    
    // cell.backgroundColor = UIColor.white.withAlphaComponent(0.25)
    tableViewCellPresenter.formatCellForPresentation(cell, json: items[indexPath.row])

    return cell
  }
}

// MARK: UITableViewDelegate
extension TodayViewController: UITableViewDelegate {
  
}
