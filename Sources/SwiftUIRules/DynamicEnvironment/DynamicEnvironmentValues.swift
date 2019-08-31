//
//  DynamicEnvironmentValues.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 28.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

/**
 * A DynamicEnvironmentValues can yield values for `DynamicEnvironmentKeys`.
 * It is a protocol similar to the `EnvironmentValues` struct in SwiftUI.
 *
 * User code should not directly use the resolver and store functions, but
 * rather rely on the subscript and `optional` functions.
 */
public protocol DynamicEnvironmentValues {

  func resolveValueForTypeID(_ typeID: ObjectIdentifier) -> Any?
  
  mutating func storeValue<V>(_ value: V, forTypeID typeID: ObjectIdentifier)

  func defaultValue<K: DynamicEnvironmentKey>(for key: K.Type) -> K.Value
}

public extension DynamicEnvironmentValues { // lookup using type

  func defaultValue<K: DynamicEnvironmentKey>(for key: K.Type) -> K.Value {
    return K.defaultValueInContext(self)
  }

  /**
   * Returns a value for the `DynamicEnvironmentKey`, or the defaultValue of
   * the key if the `resolveValueForTypeID` returns no value.
   */
  subscript<K: DynamicEnvironmentKey>(key: K.Type) -> K.Value {
    // Note a subscript w/o a name can be used on types w/o adding `.self`!!
    set { storeValue(newValue, forTypeID: ObjectIdentifier(key)) }
    get { return optional(key) ?? defaultValue(for: key) }
  }
  
  /**
   * Returns a value for the `DynamicEnvironmentKey` or `nil` in case the
   * `resolveValueForTypeID` returned no value (it could not be dynamically
   * generated).
   * Hence the result is optional.
   *
   * Note: Avoid having to check for optionality in user code. Rather use the
   *       subscript, which falls back to the defaultValue of the environment
   *       key.
   */
  func optional<K: DynamicEnvironmentKey>(_ key: K.Type) -> K.Value? {
    let typeID = ObjectIdentifier(key)
    
    if debugPrints {
      print("optional lookup key:", key, "typeID:", typeID.short)
    }
    
    if let v = resolveValueForTypeID(typeID) {
      guard let typed = v as? K.Value else {
        print( // TBD: no generic logger? Want to avoid ZeeQL here
          "Could not map rule result to expected value:\n",
          "  value:   ", v, "\n",
          "  expected:", K.Value.self
        )
        return nil
      }
      return typed // TBD: cache?
    }

    return nil
  }
  
}
