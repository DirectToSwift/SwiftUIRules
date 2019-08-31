//
//  DynamicEnvironmentKey.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 20.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

import protocol SwiftUI.EnvironmentKey

/**
 * Environment keys which are dynamically evaluated against the RuleContext.
 *
 * The additional `defaultValueInContext` is essentially a replica of the
 * `DefaultAssignment` in D2W.
 */
public protocol DynamicEnvironmentKey: EnvironmentKey {
  
  static func defaultValueInContext(_ context: DynamicEnvironmentValues)
              -> Self.Value
  
}

public extension DynamicEnvironmentKey {
  
  /**
   * Default implementation just calls the `defaultValue` of the
   * SwiftUI `EnvironmentKey`.
   */
  static func defaultValueInContext(_ context: DynamicEnvironmentValues)
              -> Self.Value
  {
    return defaultValue
  }
}
