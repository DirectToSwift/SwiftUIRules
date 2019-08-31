//
//  EnvironmentKeys.swift
//  RulesTestApp-Mobile
//
//  Created by Helge Heß on 30.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

import SwiftUIRules
import SwiftUI

extension DynamicEnvironmentPathes {

  var title : String {
    set { self[dynamic: TitleEnvironmentKey.self] = newValue }
    get { self[dynamic: TitleEnvironmentKey.self] }
  }
  var navigationBarTitle : String {
    set { self[dynamic: NavigationBarTitleEnvironmentKey.self] = newValue }
    get { self[dynamic: NavigationBarTitleEnvironmentKey.self] }
  }

  var priority: Priority {
    set { self[dynamic: PriorityEnvironmentKey.self] = newValue }
    get { self[dynamic: PriorityEnvironmentKey.self] }
  }

  var fancyColor : Color {
    set { self[dynamic: FancyColorEnvironmentKey.self] = newValue }
    get { self[dynamic: FancyColorEnvironmentKey.self] }
  }
  
  var todo : Todo {
    set { self[dynamic: TodoEnvironmentKey.self] = newValue }
    get { self[dynamic: TodoEnvironmentKey.self] }
  }
}

struct TitleEnvironmentKey: DynamicEnvironmentKey {
  public static let defaultValue = "Hello World"
}

struct NavigationBarTitleEnvironmentKey: DynamicEnvironmentKey {
  public static let defaultValue = TitleEnvironmentKey.defaultValue
}

struct PriorityEnvironmentKey: DynamicEnvironmentKey {
  public static let defaultValue = Priority.normal
}

struct FancyColorEnvironmentKey: DynamicEnvironmentKey {
  public static let defaultValue = Color.black
}

struct TodoEnvironmentKey: DynamicEnvironmentKey {
  public static let defaultValue =
    Todo(title: "", completed: false, priority: .normal)
}
