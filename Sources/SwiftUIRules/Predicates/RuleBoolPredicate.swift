//
//  RuleBoolPredicate.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 29.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

public struct RuleBoolPredicate: RulePredicate, Equatable {
  
  public static let yes = RuleBoolPredicate(value: true)
  public static let no  = RuleBoolPredicate(value: false)
  
  private let value : Bool
  
  public func evaluate(in ruleContext: RuleContext) -> Bool {
    return value
  }
  
  public var rulePredicateComplexity: Int {
    // This means that a boolean predicate has a lower predicate than
    // any other predicate, even simple ones.
    return 0
  }
}
