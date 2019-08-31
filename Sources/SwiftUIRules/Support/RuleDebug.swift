//
//  RuleDebug.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 29.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

#if DEBUG
  internal let debugPrints = false
#else
  internal let debugPrints = false
#endif

extension ObjectIdentifier {
  
  var short: String {
    let s = String(describing: self)
    let match = "ObjectIdentifier(0x0000000"
    if s.hasPrefix(match) {
      return "0x" + String(s.dropFirst(match.count).dropLast())
    }
    return s
  }
  
}
