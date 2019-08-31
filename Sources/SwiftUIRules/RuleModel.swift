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
 * Though rules can also be constructed manually and then added using `addRule`.
 */
public final class RuleModel {
  
  public static let defaultModel: RuleModel = {
    let model = RuleModel(fallbackModel: nil)
    // TODO: add the default rules :-)
    return model
  }()
  
  let fallbackModel: RuleModel? // kinda the model group?
  
  public init(fallbackModel: RuleModel? = RuleModel.defaultModel) {
    self.fallbackModel = fallbackModel
  }
  
  // TODO: should keep a priority sorted/keyed model
  
  private var oidToRules = [ ObjectIdentifier : [ Rule ] ]()
    // bah, fixme
  
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

extension RuleModel: RuleCandidate {
  
  public var candidateKeyType: ObjectIdentifier {
    return ObjectIdentifier(RuleModel.self) // hack
  }
  
  public func isCandidateForKey<K: DynamicEnvironmentKey>(_ key: K.Type)
              -> Bool
  {
    oidToRules[ObjectIdentifier(key)] != nil
  }
}


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

extension RuleModel : ExpressibleByArrayLiteral {
  public typealias ArrayLiteralElement = RuleLiteral
  
  public convenience init(arrayLiteral rules: RuleLiteral...) {
    self.init(fallbackModel: nil)
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
