//
//  RuleClosurePredicate.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 29.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

public struct RuleClosurePredicate: RulePredicate {
  
  private let predicate : ( RuleContext ) -> Bool
  
  public init(predicate: @escaping ( RuleContext ) -> Bool) {
    self.predicate = predicate
  }

  public func evaluate(in ruleContext: RuleContext) -> Bool {
    return predicate(ruleContext)
  }
}
