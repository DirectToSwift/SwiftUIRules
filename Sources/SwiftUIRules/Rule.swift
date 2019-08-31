//
//  Rule.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 23.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

/**
 * A Rule consists of three major components:
 * - a predicate, also known as the "left hand side" or lhs
 * - an action,   also known as the "right hand side" or rhs
 * - a priority
 *
 * The predicate defines whether a rule is active for a given context. For
 * example if a rule has such a qualifier:
 *
 *     \.user.role == "Manager"
 *
 * It will only be considered for evaluation if the current user has a Manager
 * role.
 *
 * The RuleAction defines what gets executed when a rule was selected for
 * evaluation. If the rule was the best condidate for a given query, the
 * framework will call the `fireInContext()` method on the action.
 * Most often the RuleAction will be an object of the RuleAssignment class,
 * sometimes a RuleKeyAssignment.
 * Sample:
 *
 *     \.user.role == "Manager" => bannerColor <= "red"
 *
 * Note that the name 'Action' does not imply that the object somehow modifies
 * state in the context, it usually does not have any sideeffects. Instead the
 * action just *returns* the value for a requested key by performing some
 * evaluation/calculation.
 *
 * Finally the 'priority' is used to select a rule when there are multiple
 * matching rules. In models you usually use constants like 'fallback' or
 * 'high'.
 *
 *     (\.firstPageName <= "Main'  ).priority(.fallback)
 *     (\.firstPageName <= "MyMain").priority(.default)
 *
 * The 'fallback' priority is most often in frameworks to specify
 * defaults for keys which can then be overridden in user provided models.
 *
 */
public final class Rule {
  // Note: immutable class because it is passed around a bit (too lazy for 🐄)
  
  public struct Priority: Comparable {
    
    public let rawValue : Int16
    public init(_ rawValue: Int16) { self.rawValue = rawValue }
    
    public static let important = Priority(1000)
    public static let veryHigh  = Priority(200)
    public static let high      = Priority(150)
    public static let normal    = Priority(100)
    public static let low       = Priority(50)
    public static let veryLow   = Priority(5)
    public static let fallback  = Priority(0)
    
    public static func < (lhs: Priority, rhs: Priority) -> Bool {
      return lhs.rawValue < rhs.rawValue
    }
  }
  
  public let predicate : RulePredicate
  public let action    : RuleCandidate & RuleAction
  public let priority  : Priority
  
  public init(when predicate : RulePredicate,
              do   action    : RuleCandidate & RuleAction,
              at   priority  : Priority = .normal)
  {
    self.predicate = predicate
    self.action    = action
    self.priority  = priority
  }
  
  /**
   * Return a new rule at a different priority.
   *
   *     (\.title <= "Hello").priority(.high)
   */
  public func priority(_ priority: Priority) -> Rule {
    return Rule(when: predicate, do: action, at: priority)
  }
  
  func hasHigherPriority(than other: Rule) -> Bool {
    if self === other { return false }
    
    if priority != other.priority { return priority > other.priority }
    return predicate.rulePredicateComplexity
         > other.predicate.rulePredicateComplexity
  }
}

extension Rule: RuleCandidate {
  
  public var candidateKeyType: ObjectIdentifier {
    return action.candidateKeyType
  }
  public func isCandidateForKey<K: DynamicEnvironmentKey>(_ key: K.Type) -> Bool {
    return action.isCandidateForKey(key)
  }
  
}

extension Rule: RuleAction {
  
  public func fireInContext(_ context: RuleContext) -> Any? {
    return action.fireInContext(context)
  }
  
}

extension Rule: CustomStringConvertible {
  
  public var description: String {
    var ms = "<Rule:"
    if let b = predicate as? RuleBoolPredicate {
      if b == RuleBoolPredicate.yes { ms += " *true*\n"}
      else { ms += " *false*\n"}
    }
    else {
      ms += "\n  when: \(predicate)\n"
    }
    ms += "  do: \(action)\n"
    if priority != .normal { ms += "  @\(priority.rawValue)\n" }
    ms += ">"
    return ms
  }
}

extension Rule.Priority {
  
  public init?(_ string: String) {
    if string.isEmpty { self = .normal; return }
    if let i = Int16(string) { self.rawValue = i; return }
    
    switch string.lowercased() {
      case "important": self = .important
      case "very high": self = .veryHigh
      case "high":      self = .high
      case "normal":    self = .normal
      case "default":   self = .normal
      case "low":       self = .low
      case "very low":  self = .veryLow
      case "fallback":  self = .fallback
      default:
        assertionFailure("unexpected priority: \(string)")
        return nil
    }
  }
}
