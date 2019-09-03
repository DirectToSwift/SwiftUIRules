//
//  RuleContext.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 19.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

/**
 * The `RuleContext` holds the state of the rule system for a given environment.
 *
 * It is itself an environment key and can be accessed using
 *
 *     @Environment(\.ruleContext) var ruleContext
 *
 * Keys in the context can be accessed as regular properties, for example:
 *
 *     ruleContext.color
 *
 * Or as usual as regular environment keys:
 *
 *     @Environment(\.color) var color
 *
 * The context has a state dictionary mapping `DynamicEnvironmentKeys` to their
 * values. Which means you can explicitly fill in values:
 *
 *     var body: some View {
 *       Text()
 *         .environment(\.color, .red)
 *     }
 *
 * If a RuleContext has state for a key, it always has preference over the
 * rules.
 * Its true power stems however from the fact that keys can be looked up using
 * the associated `RuleModel`:
 *
 *     ruleModel
 *       .add(\todo.status == "pending" => \.color <= .yellow)
 *       .add(\todo.status == "overdue" => \.color <= .red)
 *       .add(\todo.status == "done"    => \.color <= .gray)
 *
 * That is transparent to the View, it can still access the dynamic key using:
 *
 *     @Environment(\.color) var color
 *
 */
public struct RuleContext: DynamicEnvironmentValues {
  
  public let ruleModel : RuleModel
  
  private var state = [ ObjectIdentifier : Any ]()
    // We'd like to avoid this and just use `EnvironmentValues`, but we
    // can't. Because `EnvironmentValues` has nothing to check for the
    // existance of a key.
  
  public init(ruleModel: RuleModel) {
    self.ruleModel = ruleModel
  }
  
  @inline(__always)
  private func clearCache() {} // TBD
  
  // lookup using typeID

  public func resolveValueForTypeID(_ typeID: ObjectIdentifier) -> Any? {
    if crazyTypeQueryHack(typeID) { return nil }
    
    if let value = state[typeID] {
      if debugPrints { print("Resolved from state:", typeID.short, "=>", value) }
      return value
    }
    if let value = ruleModel.resolveValueForTypeID(typeID, in: self) {
      if debugPrints {
        print("Resolved using model:", typeID.short, "=>", value)
      }
      // The problem w/ caching is that our structs should stay immutable.
      // We could maybe use an object for the cache and be careful w/ CoW.
      return value // TBD: cache?
    }
    return nil
  }

  public mutating func storeValue<V>(_ value: V,
                                     forTypeID typeID: ObjectIdentifier)
  {
    if crazyTypeQueryHack(typeID) { return }

    clearCache()
    if debugPrints { print("Push to state:", typeID.short, "=", value) }
    state[typeID] = value
  }
  
  public func defaultValue<K: DynamicEnvironmentKey>(for key: K.Type) -> K.Value
  {
    return K.defaultValue
  }
}

extension RuleContext: CustomStringConvertible {
 
  public var description: String {
    var ms = "<RuleCtx:\n"
    ms += "  model=\(ruleModel)\n"
    if state.isEmpty {
      ms += "  no state>"
    }
    else {
      ms += "  state:\n"
      for ( typeID, value ) in state {
        ms += "    " + typeID.short + "=\(value)"
      }
      ms += ">"
    }
    return ms
  }
  
}

import protocol SwiftUI.EnvironmentKey
import struct   SwiftUI.EnvironmentValues

/**
 * Access the active rule context in the environment.
 *
 * To access the RuleContext from within your Views, use:
 *
 *     struct MyView: View {
 *       @Environment(\.ruleContext) var ruleContext
 *     }
 */
public struct RuleContextKey: EnvironmentKey {
  public static let defaultValue = RuleContext(ruleModel: RuleModel())
}

public extension EnvironmentValues {
  
  /**
   * Access the active rule context in the environment.
   */
  var ruleContext : RuleContext {
    set { self[RuleContextKey.self] = newValue }
    get { self[RuleContextKey.self] }
  }
  
}
public extension RuleContext {
  var ruleContext : RuleContext { return self }
}


// MARK: - KeyPath Type Reflection

fileprivate var queryTypeMode = false
fileprivate var lastTypeQuery : ObjectIdentifier?

public extension RuleContext {
  
  @inline(__always)
  fileprivate func crazyTypeQueryHack(_ typeID: ObjectIdentifier) -> Bool {
    guard queryTypeMode else { return false }
    if debugPrints { print("  crazyTypeQueryHack:", typeID.short) }
    assert(lastTypeQuery == nil)
    lastTypeQuery = typeID
    return true
  }
  
  static
  func typeIDForKeyPath<Value>(_ keyPath: Swift.KeyPath<RuleContext, Value>)
       -> ObjectIdentifier
  {
    // What a dirty hack :->
    if debugPrints { print("TypeQuery lookup:", keyPath, Value.self) }
    
    // sigh, it can be recursive
    let storeQueryTypeMode = queryTypeMode
    let storeQueryType     = lastTypeQuery
    queryTypeMode = true
    lastTypeQuery = nil
    defer {
      queryTypeMode = storeQueryTypeMode
      lastTypeQuery = storeQueryType
    }
    
    let tempContext = RuleContext(ruleModel: RuleModel(nil))
    _ = tempContext[keyPath: keyPath]

    guard let typeID = lastTypeQuery else {
      fatalError("could not reflect type of keypath: \(keyPath)")
    }
    
    if debugPrints { print("=>", typeID.short) }
    
    return typeID
  }
  
}

