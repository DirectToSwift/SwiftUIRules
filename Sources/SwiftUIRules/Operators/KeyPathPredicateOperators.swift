//
//  PredicateOperators.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 01.09.19.
//

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

// e.g. \.person === manager
public func ===<Value>(lhs: Swift.KeyPath<RuleContext, Value>, rhs: Value)
              -> some RulePredicate where Value : AnyObject
{
  RuleKeyPathPredicate<Value>() { ruleContext in
    ruleContext[keyPath: lhs] === rhs
  }
}
// e.g. \.person !== manager
public func !==<Value>(lhs: Swift.KeyPath<RuleContext, Value>, rhs: Value)
              -> some RulePredicate where Value : AnyObject
{
  RuleKeyPathPredicate<Value>() { ruleContext in
    ruleContext[keyPath: lhs] !== rhs
  }
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

// e.g. \.person === manager
public func ===<Value>(lhs: Swift.KeyPath<RuleContext, Value>,
                       rhs: Swift.KeyPath<RuleContext, Value>)
              -> some RulePredicate where Value : AnyObject
{
  RuleKeyPathPredicate<Value>() { ruleContext in
    ruleContext[keyPath: lhs] === ruleContext[keyPath: rhs]
  }
}
// e.g. \.person !== manager
public func !==<Value>(lhs: Swift.KeyPath<RuleContext, Value>,
                       rhs: Swift.KeyPath<RuleContext, Value>)
              -> some RulePredicate where Value : AnyObject
{
  RuleKeyPathPredicate<Value>() { ruleContext in
    ruleContext[keyPath: lhs] !== ruleContext[keyPath: rhs]
  }
}
