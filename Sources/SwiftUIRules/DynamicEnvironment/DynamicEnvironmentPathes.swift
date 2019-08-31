//
//  DynamicEnvironmentPathes.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 29.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

import struct SwiftUI.EnvironmentValues

/**
 * Use to share the environment keypathes between
 * `EnvironmentValues` and the `RuleContext`.
 * Both can then be accessed using `\.entity` like keypathes.
 *
 * DynamicEnvironmentPathes is only used to share the implementation,
 * it is not used as an own type.
 */
public protocol DynamicEnvironmentPathes {
  
  subscript<K: DynamicEnvironmentKey>(dynamic key: K.Type) -> K.Value {
    set get
  }

}

extension EnvironmentValues: DynamicEnvironmentPathes {
  
  public subscript<K: DynamicEnvironmentKey>(dynamic key: K.Type) -> K.Value {
    set {
      // Hm, we really want to write to the environment values? But we can't,
      // because we can't check whether the environment contains a value
      // w/o fatal-erroring? :-)
      // So we need to sideline our own storage?
      ruleContext[key] = newValue
    }
    get { return ruleContext[key] }
  }
}

extension RuleContext: DynamicEnvironmentPathes {
  
  public subscript<K: DynamicEnvironmentKey>(dynamic key: K.Type) -> K.Value {
    set { self[key] = newValue }
    get { return self[key] }
  }

}
