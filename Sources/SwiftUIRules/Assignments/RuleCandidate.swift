//
//  RuleCandidate.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 23.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

/**
 * Used to determine candidates for a key resolution.
 *
 * Implemented by the assignment classes.
 */
public protocol RuleCandidate {
  func isCandidateForKey<K: DynamicEnvironmentKey>(_ key: K.Type) -> Bool
  
  // hacky, to support adding generic rules into the OID cache of the model
  var candidateKeyType: ObjectIdentifier { get }
}
