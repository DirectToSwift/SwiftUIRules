//
//  RuleTypeIDAssignment.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 29.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

/**
* RuleTypeIDAssignment
*
* This class just returns its value if its fired.
*
* In a model it looks like:
*
*     \user.role = 'Manager' => \.bannerColor = "red"
*
*/
public struct RuleTypeIDAssignment<Value>: RuleCandidate, RuleAction {
  
  public let typeID   : ObjectIdentifier
  public let constant : Value
  #if DEBUG
    let debugInfo     : String
  #endif
  
  public init(_ typeID: ObjectIdentifier, _ constant: Value,
              debugInfo: String = "")
  {
    self.typeID   = typeID
    self.constant = constant
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
    return constant
  }
}

extension RuleTypeIDAssignment: CustomStringConvertible {
  
  public var description: String {
    #if DEBUG
      return "<KPA[\(typeID.short)]: " + debugInfo + ">"
    #else
      return "<RuleTypeIDAssignment \(typeID) \(constant)>"
    #endif
  }
}

public extension RuleTypeIDAssignment {

  init<K: DynamicEnvironmentKey>(_ key: K.Type, _ constant: K.Value)
           where Value == K.Value
  {
    self.init(ObjectIdentifier(key), constant)
  }
  
  /**
   * Careful, this only works properly for single-key keypathes.
   *
   * E.g. don't: \.person.name = "Hello"
   */
  init(_ keyPath: KeyPath<RuleContext, Value>, _ constant: Value) {
    // FIXME: This is not quite what we want yet. The user could "write" to
    //        an arbitrary keypath, e.g. \.person.name = "Donald".
    //        I guess in theory it is possible to make that work if OIDs
    //        of the keypathes are interned?
    //        Then we could 'assign' them just like any other dynamic envkey?
    //        Note sure yet.
    let typeID = RuleContext.typeIDForKeyPath(keyPath)
    #if DEBUG
      let debugInfo =
            "type=\(typeID.short) keyPath=\(keyPath) constant=\(constant)"
    #else
      let debugInfo = ""
    #endif
    self.init(typeID, constant, debugInfo: debugInfo)
  }
}
