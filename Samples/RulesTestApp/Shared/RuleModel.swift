//
//  RuleModel.swift
//  RulesTestApp-Mobile
//
//  Created by Helge Heß on 30.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

import SwiftUIRules

let ruleModel : RuleModel = [
  /*
  | predicate          |=>| env-key    |<=| value if predicate matches |
   */
  \.todo.title != ""    => \.priority   <= \.todo.priority,
  \.todo.title != ""    => \.title      <= \.todo.title,
                           \.title      <= "Swift Rulez",
                        
  \.priority == .low    => \.fancyColor <= .gray,
  \.priority == .high   => \.fancyColor <= .red,
  \.priority == .normal => \.fancyColor <= .black
]
