//
//  RuleTypeIDPathAssignment.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 29.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

/**
* RuleTypeIDPathAssignment
*
* This RuleAction object evaluates the action value as a lookup against the
* _context_. Which then can trigger recursive rule evaluation (if the queried
* key is itself a rule based value).
* 
* In a model it looks like:
*
*     \user.role == "Manager" => \.bannerColor <= \.defaultColor
*
* The `bannerColor <= defaultColor` represents the RuleKeyAssignment.
* When executed, it will query the RuleContext for the 'defaultColor' and
* will return that in fireInContext().
*
* Note that this object does *not* assign to the \.bannerColor value.
* It simply returns the value in fireInContext() for further processing at
* upper layers.
*
* @see RuleAction
* @see RuleAssignment
*/
public struct RuleTypeIDPathAssignment<Value>: RuleCandidate, RuleAction {
  
  public let typeID  : ObjectIdentifier
  public let keyPath : Swift.KeyPath<RuleContext, Value>
  #if DEBUG
    let debugInfo    : String
  #endif
  
  public init(_ typeID: ObjectIdentifier,
              _ keyPath: Swift.KeyPath<RuleContext, Value>,
              debugInfo: String = "")
  {
    self.typeID  = typeID
    self.keyPath = keyPath
    #if DEBUG
      self.debugInfo = debugInfo
    #endif
  }
  
  public var candidateKeyType: ObjectIdentifier {
    return typeID
  }

  public func isCandidateForKey<K: DynamicEnvironmentKey>(_ key: K.Type)
              -> Bool
  {
    return self.typeID == ObjectIdentifier(key)
  }
  
  public func fireInContext(_ context: RuleContext) -> Any? {
    return context[keyPath: keyPath]
  }
}

extension RuleTypeIDPathAssignment: CustomStringConvertible {
  
  public var description: String {
    #if DEBUG
      return "<KPAP[\(typeID.short)]: " + debugInfo + ">"
    #else
      return "<RuleTypeIDPathAssignment \(typeID) \(keyPath)>"
    #endif
  }
}

public extension RuleTypeIDPathAssignment {
  
  /**
   * Careful, this only works properly for single-key keypathes.
   *
   * E.g. don't: \.person.name = "Hello"
   */
  init(_ keyPath   : Swift.KeyPath<RuleContext, Value>,
       _ valuePath : Swift.KeyPath<RuleContext, Value>)
  {
    // FIXME: This is not quite what we want yet. The user could "write" to
    //        an arbitrary keypath, e.g. \.person.name = "Donald".
    //        I guess in theory it is possible to make that work if OIDs
    //        of the keypathes are interned?
    //        Then we could 'assign' them just like any other dynamic envkey?
    //        Note sure yet.
    let typeID = RuleContext.typeIDForKeyPath(keyPath)
    #if DEBUG
      let debugInfo =
            "type=\(typeID.short) keyPath=\(keyPath) valuePath=\(valuePath)"
    #else
      let debugInfo = ""
    #endif
    self.init(typeID, valuePath, debugInfo: debugInfo)
  }
}
