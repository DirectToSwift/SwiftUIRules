//
//  CompoundPredicateOperators.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 01.09.19.
//

// e.g. !predicate
public prefix func !<P: RulePredicate>(_ base: P) -> RuleNotPredicate<P> {
  RuleNotPredicate(predicate: base)
}

// e.g. \.state == done && \.color == yellow
public
func &&<LHS, RHS>(lhs: LHS, rhs: RHS) -> RuleAndPredicate2<LHS, RHS>
                  where LHS: RulePredicate, RHS: RulePredicate
{
  RuleAndPredicate2(lhs, rhs)
}
// e.g. \.state == done || \.color == yellow
public
func ||<LHS, RHS>(lhs: LHS, rhs: RHS) -> RuleOrPredicate2<LHS, RHS>
                  where LHS: RulePredicate, RHS: RulePredicate
{
  RuleOrPredicate2(lhs, rhs)
}
