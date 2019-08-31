//
//  RuleValueAssignment.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 23.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

public struct RuleValueAssignment<K: DynamicEnvironmentKey>
              : RuleCandidate, RuleAction
{
  // FIXME: drop this one, not that useful anymore
  
  public let key       : K.Type
  public let constant  : K.Value
  
  public init(_ key: K.Type, _ constant: K.Value) {
    self.key      = key
    self.constant = constant
  }

  public var candidateKeyType: ObjectIdentifier {
    return ObjectIdentifier(key)
  }

  public func isCandidateForKey<K: DynamicEnvironmentKey>(_ key: K.Type)
              -> Bool
  {
    return self.key == key
  }
  
  public func fireInContext(_ context: RuleContext) -> Any? {
    return constant
  }
}
