//
//  RuleOperators.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 29.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

infix operator => : AssignmentPrecedence

/**
 * Operator to combine a predicate with an action to form the final rule.
 *
 * Example:
 *
 *     \.person.name != "Donald" => \.title <= "hello"
 *
 */
public func =>(lhs: RulePredicate, rhs: RuleCandidate & RuleAction) -> Rule {
  Rule(when: lhs, do: rhs)
}
