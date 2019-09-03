//
//  RuleModel.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 19.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

/**
 * A rule model is just an ordered and keyed set of `Rule` values.
 *
 * To add rules the SwiftUIRule operators are usually used, for example:
 *
 *     ruleModel
 *       .add(\todo.status == "pending" => \.color <= .yellow)
 *       .add(\todo.status == "overdue" => \.color <= .red)
 *       .add(\todo.status == "done"    => \.color <= .gray)
 *
 * You can also use to setup the rules:
 *
 *     RuleModel(
 *       \todo.status == "pending" => \.color <= .yellow,
 *       \todo.status == "overdue" => \.color <= .red
 *     )
 *
 * Or use the literal convertible:
 *
 *     let ruleModel : RuleModel = [
 *       \todo.status == "pending" => \.color <= .yellow,
 *       \todo.status == "overdue" => \.color <= .red
 *     ]
 *
 * Though rules can also be constructed manually and then added using `addRule`.
 */
public final class RuleModel {
   
  let fallbackModel: RuleModel? // kinda the model group?
  
  public init(_ fallbackModel: RuleModel? = nil, _ rules: RuleLiteral...) {
    self.fallbackModel = fallbackModel
    for rule in rules {
      addRule(rule.ruleLiteral)
    }
    if !rules.isEmpty { sortRules() }
  }
  
  /**
   * Add a fallback model to the RuleModel. The rules in the fallback model
   * will be used when none of the own rules matches (but before resorting
   * to defaults!)
   */
  public func fallback(_ fallbackModel: RuleModel) -> RuleModel {
    let newModel : RuleModel
    if let oldFallback = self.fallbackModel { // nest fallbacks
      newModel = RuleModel(fallbackModel.fallback(oldFallback))
    }
    else {
      newModel = RuleModel(fallbackModel)
    }
    newModel.oidToRules   = self.oidToRules
    newModel.sortRequired = self.sortRequired
    return newModel
  }

  private var oidToRules = [ ObjectIdentifier : [ Rule ] ]()
  
  private var sortRequired = false
  
  private func sortRules() {
    for ( typeID, rules ) in oidToRules {
      if rules.isEmpty { oidToRules.removeValue(forKey: typeID); continue }
      oidToRules[typeID] = rules.sorted { $0.hasHigherPriority(than: $1) }
    }
    sortRequired = false
  }
  
  @discardableResult
  public func addRule(_ rule: Rule) -> Self {
    let typeID = rule.candidateKeyType
    if oidToRules[typeID] == nil {
      oidToRules[typeID] = [ rule ]
      return self
    }
    oidToRules[typeID]!.append(rule)
    sortRequired = true
    return self
  }
  
  func resolveValueForTypeID(_ typeID: ObjectIdentifier,
                             in context: RuleContext) -> Any?
  {
    if sortRequired { sortRules() }
    
    // lookup candidates
    let rules = oidToRules[typeID] ?? []
    
    guard let match =
      rules.first(where: { $0.predicate.evaluate(in: context) }) else
    {
      return fallbackModel?.resolveValueForTypeID(typeID, in: context)
    }
    
    return match.fireInContext(context)
  }
  
}

extension RuleModel: CustomStringConvertible {
  
  public var description: String {
    if oidToRules.isEmpty { return "<Rules: Empty>" }
    var ms = "<Rules:"
    
    for (_, rules) in oidToRules {
      for rule in rules {
        ms += "\n  "
        ms += String(describing: rule)
      }
    }

    ms += "\n>"
    return ms
  }
}


#if false // Doesn't work w/ candidateKeyType infrastructure
// MARK: - Using RuleModels as Rules

extension RuleModel: RuleCandidate {
  // Note: Does not work yet.
  
  public var candidateKeyType: ObjectIdentifier {
    return // would need to fix this.
  }
  
  public func isCandidateForKey<K: DynamicEnvironmentKey>(_ key: K.Type)
              -> Bool
  {
    oidToRules[ObjectIdentifier(key)] != nil
  }
}
#endif


// MARK: - Convenience adders

public extension RuleModel {

  @discardableResult
  func add(_ rule: Rule) -> Self {
    return addRule(rule)
  }

  @discardableResult
  func add(_ action: RuleCandidate & RuleAction) -> Self {
    return addRule(Rule(when: RuleBoolPredicate.yes, do: action))
  }

  @discardableResult
  func add(_ predicate: @escaping ( RuleContext ) -> Bool,
           action: RuleCandidate & RuleAction) -> Self
  {
    return addRule(Rule(when: RuleClosurePredicate(predicate: predicate),
                        do: action))
  }
}


// MARK: - Literals

/**
 * Literal convertible:
 *
 *     let ruleModel : RuleModel = [
 *       \todo.status == "pending" => \.color <= .yellow,
 *       \todo.status == "overdue" => \.color <= .red
 *     ]
 *
 */
extension RuleModel : ExpressibleByArrayLiteral {
  public typealias ArrayLiteralElement = RuleLiteral
  
  public convenience init(arrayLiteral rules: RuleLiteral...) {
    self.init(nil)
    rules.forEach { self.addRule($0.ruleLiteral) }
    sortRules()
  }
}
public protocol RuleLiteral {
  var ruleLiteral: Rule { get }
}
extension Rule: RuleLiteral {
  public var ruleLiteral: Rule { self }
}
extension RuleAction where Self: RuleCandidate {
  public var ruleLiteral: Rule {
    Rule(when: RuleBoolPredicate.yes, do: self)
  }
}
extension RuleTypeIDAssignment     : RuleLiteral {}
extension RuleTypeIDPathAssignment : RuleLiteral {}
