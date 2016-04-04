//
//  MockShortcutItems.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/4/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit

/**
 *  Mocks `shortcutItems` so we don't pollute our app data
 */
protocol MockShortcutItems {
  var shortcutItems: [UIApplicationShortcutItem]? { get set }
}

extension UIApplication: MockShortcutItems { }