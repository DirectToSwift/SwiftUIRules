//
//  DynamicEnvironmentKey.swift
//  SwiftUIRules
//
//  Created by Helge Heß on 20.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

import protocol SwiftUI.EnvironmentKey

/**
 * Environment keys which are dynamically evaluated against the RuleContext.
 */
public protocol DynamicEnvironmentKey: EnvironmentKey {}
