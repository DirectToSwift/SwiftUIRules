//
//  RuleAction.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 23.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

public protocol RuleAction {
  
  func fireInContext(_ context: RuleContext) -> Any?
  
}
