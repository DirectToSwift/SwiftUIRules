//
//  RuleCompoundPredicate.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 29.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

// Provide a default set of predicates.

public protocol RuleCompoundPredicate: RulePredicate {
  
  var predicates : [ RulePredicate ] { get }
}

public extension RuleCompoundPredicate {
  var rulePredicateComplexity: Int {
    predicates.reduce(0) { $0 + $1.rulePredicateComplexity }
  }
}

public struct RuleAndPredicate2<P1, P2>: RuleCompoundPredicate
                where P1: RulePredicate, P2: RulePredicate
{
  public let p1: P1
  public let p2: P2
  
  public var predicates : [ RulePredicate ] { [ p1, p2 ] }
  
  public init(_ p1: P1, _ p2: P2) {
    self.p1 = p1
    self.p2 = p2
  }
  public var rulePredicateComplexity: Int {
    p1.rulePredicateComplexity + p2.rulePredicateComplexity
  }

  public func evaluate(in ruleContext: RuleContext) -> Bool {
    return p1.evaluate(in: ruleContext) && p2.evaluate(in: ruleContext)
  }
  
}
public struct RuleOrPredicate2<P1, P2>: RuleCompoundPredicate
                where P1: RulePredicate, P2: RulePredicate
{
  public let p1: P1
  public let p2: P2
  
  public var predicates : [ RulePredicate ] { [ p1, p2 ] }
  
  public init(_ p1: P1, _ p2: P2) {
    self.p1 = p1
    self.p2 = p2
  }
  public var rulePredicateComplexity: Int {
    p1.rulePredicateComplexity + p2.rulePredicateComplexity
  }

  public func evaluate(in ruleContext: RuleContext) -> Bool {
    return p1.evaluate(in: ruleContext) || p2.evaluate(in: ruleContext)
  }
  
}

public struct RuleAndPredicate: RuleCompoundPredicate {
  
  public let predicates : [ RulePredicate ]
  
  public init(predicates: [ RulePredicate ]) {
    self.predicates = predicates
  }

  public func evaluate(in ruleContext: RuleContext) -> Bool {
    for predicate in predicates {
      if !predicate.evaluate(in: ruleContext) { return false }
    }
    return true
  }
  
}
public struct RuleOrPredicate: RuleCompoundPredicate {
  
  public let predicates : [ RulePredicate ]
  
  public init(predicates: [ RulePredicate ]) {
    self.predicates = predicates
  }

  public func evaluate(in ruleContext: RuleContext) -> Bool {
    for predicate in predicates {
      if predicate.evaluate(in: ruleContext) { return true }
    }
    return false
  }
}

public struct RuleNotPredicate<P: RulePredicate>: RulePredicate {
  
  public let predicate : P
  
  public init(predicate: P) {
    self.predicate = predicate
  }

  public func evaluate(in ruleContext: RuleContext) -> Bool {
    return !predicate.evaluate(in: ruleContext)
  }
}
