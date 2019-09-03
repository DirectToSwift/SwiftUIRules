//
//  RuleKeyPathPredicate.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 29.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

public struct RuleKeyPathPredicate<Value>: RulePredicate {
  // This is like a ClosurePredicate, but it preserves the static type.
  // Which has to be passed in explicitly! Can't add further constraints to
  // the init, like init() where Value: Equatable
  
  private let predicate : ( RuleContext ) -> Bool
  #if DEBUG
    private let debugInfo : String
  #endif
  
  public init(debugInfo: String = "",
              predicate: @escaping ( RuleContext ) -> Bool)
  {
    #if DEBUG
      self.debugInfo = debugInfo
    #endif
    self.predicate = predicate
  }

  public func evaluate(in ruleContext: RuleContext) -> Bool {
    return predicate(ruleContext)
  }
}

extension RuleKeyPathPredicate: CustomStringConvertible {
  
  public var description: String {
    #if DEBUG
      return "<KPP: " + debugInfo + ">"
    #else
      return "<RuleKeyPathPredicate>"
    #endif
  }
}

public enum RuleComparisonOperation {
  
  case equal
  case notEqual
  case lessThan
  case greaterThan
  case lessThanOrEqual
  case greaterThanOrEqual
  
  public func compare<V: Comparable>(_ lhs: V, _ rhs: V) -> Bool {
    switch self {
      case .equal:              return lhs == rhs
      case .notEqual:           return lhs != rhs
      case .lessThan:           return lhs <  rhs
      case .greaterThan:        return lhs >  rhs
      case .lessThanOrEqual:    return lhs <= rhs
      case .greaterThanOrEqual: return lhs >= rhs
    }
  }
}


public extension RuleKeyPathPredicate {

  init<Value>(keyPath: Swift.KeyPath<RuleContext, Value>,
              value: Value) where Value: Equatable
  {
    #if DEBUG
      let debugInfo = "keyPath=\(keyPath) value=\(value)"
    #else
      let debugInfo = ""
    #endif

    self.init(debugInfo: debugInfo) { ruleContext in
      let other = ruleContext[keyPath: keyPath]
      return value == other
    }
  }
  
  init<Value>(keyPath: Swift.KeyPath<RuleContext, Value>,
              operation: RuleComparisonOperation = .equal,
              value: Value) where Value: Comparable
  {
    self.init() { ruleContext in
      return operation.compare(ruleContext[keyPath: keyPath], value)
    }
  }
}

public extension RuleKeyPathPredicate {
  init<Value>(_ lhs: Swift.KeyPath<RuleContext, Value>,
              _ rhs: Swift.KeyPath<RuleContext, Value>) where Value: Equatable
  {
    #if DEBUG
      let debugInfo = "lhs=\(lhs) rhs=\(rhs)"
    #else
      let debugInfo = ""
    #endif

    self.init(debugInfo: debugInfo) { ruleContext in
      let lhsValue = ruleContext[keyPath: lhs]
      let rhsValue = ruleContext[keyPath: rhs]
      return lhsValue == rhsValue
    }
  }
  
  init<Value>(_ lhs: Swift.KeyPath<RuleContext, Value>,
              operation: RuleComparisonOperation = .equal,
              _ rhs: Swift.KeyPath<RuleContext, Value>) where Value: Comparable
  {
    self.init() { ruleContext in
      let lhsValue = ruleContext[keyPath: lhs]
      let rhsValue = ruleContext[keyPath: rhs]
      return operation.compare(lhsValue, rhsValue)
    }
  }
}
