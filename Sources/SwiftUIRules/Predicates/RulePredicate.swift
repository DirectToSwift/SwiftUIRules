//
//  RulePredicate.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 28.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

public protocol RulePredicate {
  
  /**
   * Returns true if a predicate matches in the rule context.
   *
   * For example:
   *
   *     entity.name = 'Persons'
   *
   */
  func evaluate(in ruleContext: RuleContext) -> Bool

  /**
   * The complexity is used to sort predicates based on how many components
   * or relevance a predicate has. It is used to disambiguate in situations
   * like:
   *
   *     \.person.name == "Duck"                        => \.title <= "Donald"
   *     \.task == "show" && \.person.name == "Persons" => \.title <= "Brummel"
   *
   * In this case the second rule is checked first, because the predicate
   * has more components (and hence assumed significance).
   */
  var rulePredicateComplexity : Int { get }
  
}

public extension RulePredicate {
  var rulePredicateComplexity : Int {
    return 1
  }
}
