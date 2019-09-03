//
//  AssignmentOperators.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 01.09.19.
//

import protocol SwiftUI.View
import struct   SwiftUI.AnyView

// \.title <= "hello"
public func <= <Value>(lhs: Swift.KeyPath<RuleContext, Value>, rhs: Value)
               -> RuleTypeIDAssignment<Value>
{
  RuleTypeIDAssignment(lhs, rhs)
}

// \.title <= "hello"
public func <= <Value>(lhs: Swift.KeyPath<RuleContext, Value>,
                       rhs: Swift.KeyPath<RuleContext, Value>)
               -> RuleTypeIDPathAssignment<Value>
{
  RuleTypeIDPathAssignment(lhs, rhs)
}

// \.view <= MyView()
public func <= <V: View>(lhs: Swift.KeyPath<RuleContext, AnyView>, rhs: V)
               -> RuleTypeIDAssignment<AnyView>
{
  RuleTypeIDAssignment(lhs, AnyView(rhs))
}
public func <= (lhs: Swift.KeyPath<RuleContext, AnyView>, rhs: AnyView)
               -> RuleTypeIDAssignment<AnyView>
{
  RuleTypeIDAssignment(lhs, rhs)
}
