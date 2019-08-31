//
//  RuleKeyAssignment.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 23.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

/**
 * RuleKeyAssignment
 *
 * This RuleAction object evaluates the action value as a lookup against the
 * _context_. Which then can trigger recursive rule evaluation (if the queried
 * key is itself a rule based value).
 *
 * In a model it looks like:
 * <pre>  <code>user.role = 'Manager' => bannerColor = defaultColor</code></pre>
 *
 * The <code>bannerColor = defaultColor</code> represents the RuleKeyAssignment.
 * When executed, it will query the RuleContext for the 'defaultColor' and
 * will return that in fireInContext().
 * <p>
 * Note that this object does *not* perform a
 * takeValueForKey(value, 'bannerColor'). It simply returns the value in
 * fireInContext() for further processing at upper layers.
 *
 * @see RuleAction
 * @see RuleAssignment
 */
public struct RuleKeyAssignment<K: DynamicEnvironmentKey,
                                Value: DynamicEnvironmentKey>
              : RuleCandidate, RuleAction
{
  // FIXME: drop this one, not that useful anymore
  
  public let key   : K.Type
  public let value : Value.Type
  
  public init(_ key: K.Type, _ value: Value.Type) {
    assert(key != value, "assignment recursion!")
      // there seems to be no "where K != Value" in Swift generics?
    self.key   = key
    self.value = value
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
    return context[value]
  }
}
