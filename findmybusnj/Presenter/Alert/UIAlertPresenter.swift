//
//  UIAlertPresenter.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/8/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit

// Base enumeration type that alerts should extend from
protocol AlertEnum {
  
}

protocol UIAlertPresenter {
  func presentAlertWarning(_ type: AlertEnum) -> UIAlertController
}
