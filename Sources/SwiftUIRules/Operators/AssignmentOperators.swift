//
//  AssignmentOperators.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 01.09.19.
//

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
