//
//  RuleOperators.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 29.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

/**
 * A set of operators to build rule predicates, assignments and rules.
 *
 * Rule Predicate samples:
 *
 *     \.count       <  10
 *     \.person.name == "Duck"
 *
 * Rule Assignment samples:
 *
 *     \.title <= "1337"
 *     \.title <= \.defaultTitle
 *
 * Rule samples
 *
 *     \.count > 5                            => \.color <= .red
 *     \.count > 5 && \.person.name == "Duck" => \.color <= \.defaultColor
 */

// Hm, operator overloading. Who doesn't love it ...
// TBD: We could preserve the types /shrug


// MARK: - KeyValue

// e.g. \.person.name == "Donald"
public
func ==<Value>(lhs: Swift.KeyPath<RuleContext, Value>, rhs: Value)
              -> some RulePredicate where Value : Equatable
{
  RuleKeyPathPredicate<Value>(keyPath: lhs, value: rhs)
}

// e.g. \.person.name != "Donald"
public
func !=<Value>(lhs: Swift.KeyPath<RuleContext, Value>, rhs: Value)
              -> some RulePredicate where Value : Equatable
{
  RuleNotPredicate(predicate:
    RuleKeyPathPredicate<Value>(keyPath: lhs, value: rhs))
}

// e.g. \.person.age < 45
public
func < <Value>(lhs: Swift.KeyPath<RuleContext, Value>, rhs: Value)
              -> some RulePredicate where Value : Comparable
{
  RuleKeyPathPredicate<Value>(keyPath: lhs, operation: .lessThan, value: rhs)
}
public
func <= <Value>(lhs: Swift.KeyPath<RuleContext, Value>, rhs: Value)
              -> some RulePredicate where Value : Comparable
{
  RuleKeyPathPredicate<Value>(keyPath: lhs, operation: .lessThanOrEqual,
                              value: rhs)
}

// e.g. \.person.age > 45
public
func > <Value>(lhs: Swift.KeyPath<RuleContext, Value>, rhs: Value)
              -> some RulePredicate where Value : Comparable
{
  RuleKeyPathPredicate<Value>(keyPath: lhs, operation: .greaterThan, value: rhs)
}
public
func >= <Value>(lhs: Swift.KeyPath<RuleContext, Value>, rhs: Value)
              -> some RulePredicate where Value : Comparable
{
  RuleKeyPathPredicate<Value>(keyPath: lhs, operation: .greaterThanOrEqual,
                              value: rhs)
}


// MARK: - KeyKey

// e.g. \.person.name == \.manager.name
public
func ==<Value>(lhs: Swift.KeyPath<RuleContext, Value>,
               rhs: Swift.KeyPath<RuleContext, Value>)
              -> some RulePredicate where Value : Equatable
{
  RuleKeyPathPredicate<Value>(lhs, rhs)
}

// e.g. \.person.name != \.manager.name
public
func !=<Value>(lhs: Swift.KeyPath<RuleContext, Value>,
               rhs: Swift.KeyPath<RuleContext, Value>)
              -> some RulePredicate where Value : Equatable
{
  RuleNotPredicate(predicate: RuleKeyPathPredicate<Value>(lhs, rhs))
}

// e.g. \.person.age < \.manager.age
public
func < <Value>(lhs: Swift.KeyPath<RuleContext, Value>,
               rhs: Swift.KeyPath<RuleContext, Value>)
              -> some RulePredicate where Value : Comparable
{
  RuleKeyPathPredicate<Value>(lhs, operation: .lessThan, rhs)
}
// e.g. \.person.age <= \.manager.age
public
func <= <Value>(lhs: Swift.KeyPath<RuleContext, Value>,
                rhs: Swift.KeyPath<RuleContext, Value>)
               -> some RulePredicate where Value : Comparable
{
  RuleKeyPathPredicate<Value>(lhs, operation: .lessThanOrEqual, rhs)
}

// e.g. \.person.age > \.manager.age
public
func > <Value>(lhs: Swift.KeyPath<RuleContext, Value>,
               rhs: Swift.KeyPath<RuleContext, Value>)
              -> some RulePredicate where Value : Comparable
{
  RuleKeyPathPredicate<Value>(lhs, operation: .greaterThan, rhs)
}
// e.g. \.person.age >= \.manager.age
public
func >= <Value>(lhs: Swift.KeyPath<RuleContext, Value>,
                rhs: Swift.KeyPath<RuleContext, Value>)
               -> some RulePredicate where Value : Comparable
{
  RuleKeyPathPredicate<Value>(lhs, operation: .greaterThanOrEqual, rhs)
}


// MARK: - Compound

// e.g. !predicate
public
prefix func !<Value: RulePredicate>(_ base: Value) -> some RulePredicate {
  RuleNotPredicate(predicate: base)
}

// e.g. \.state == done && \.color == yellow
public
func &&<LHS, RHS>(lhs: LHS, rhs: RHS) -> some RulePredicate
                  where LHS: RulePredicate, RHS: RulePredicate
{
  RuleAndPredicate2(lhs, rhs)
}
// e.g. \.state == done || \.color == yellow
public
func ||<LHS, RHS>(lhs: LHS, rhs: RHS) -> some RulePredicate
                  where LHS: RulePredicate, RHS: RulePredicate
{
  RuleOrPredicate2(lhs, rhs)
}


// MARK: - Rule Assignments

// \.title <= "hello"
public
func <= <Value>(lhs: Swift.KeyPath<RuleContext, Value>, rhs: Value)
                -> RuleTypeIDAssignment<Value>
{
  RuleTypeIDAssignment(lhs, rhs)
}

// \.title <= "hello"
public
func <= <Value>(lhs: Swift.KeyPath<RuleContext, Value>,
                rhs: Swift.KeyPath<RuleContext, Value>)
                -> RuleTypeIDPathAssignment<Value>
{
  RuleTypeIDPathAssignment(lhs, rhs)
}


// MARK: - Rules

infix operator => : AssignmentPrecedence

// \.person.name != "Donald" => \.title <= "hello"
public func =>(lhs: RulePredicate, rhs: RuleCandidate & RuleAction) -> Rule {
  Rule(when: lhs, do: rhs)
}
