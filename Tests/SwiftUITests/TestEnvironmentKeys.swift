//
//  TestEnvironmentKeys.swift
//  SwiftUITests
//
//  Created by Helge Heß on 30.08.19.
//

#if canImport(UIKit)
  import class UIKit.UIColor
  typealias UXColor = UIColor
#elseif canImport(AppKit)
  import class AppKit.NSColor
  typealias UXColor = NSColor
#endif

import SwiftUIRules

struct Todo {
  enum Priority {
    case low, normal, high
  }
  
  var title     : String
  var completed : Bool
  var priority  : Priority
}

struct VerbEnvironmentKey: DynamicEnvironmentKey {
  public static let defaultValue = "view"
}

struct TitleEnvironmentKey: DynamicEnvironmentKey {
  public static let defaultValue = "Hello World"
}

struct NavigationBarTitleEnvironmentKey: DynamicEnvironmentKey {
  public static let defaultValue = TitleEnvironmentKey.defaultValue
}

struct ColorEnvironmentKey: DynamicEnvironmentKey {
  public static let defaultValue = UXColor.black
}

struct TodoEnvironmentKey: DynamicEnvironmentKey {
  public static let defaultValue =
    Todo(title: "Buy Beer", completed: false, priority: .high)
}

extension DynamicEnvironmentPathes {
  
  var verb : String {
    set { self[dynamic: VerbEnvironmentKey.self] = newValue }
    get { self[dynamic: VerbEnvironmentKey.self] }
  }
  var title : String {
    set { self[dynamic: TitleEnvironmentKey.self] = newValue }
    get { self[dynamic: TitleEnvironmentKey.self] }
  }
  var navigationBarTitle : String {
    set { self[dynamic: NavigationBarTitleEnvironmentKey.self] = newValue }
    get { self[dynamic: NavigationBarTitleEnvironmentKey.self] }
  }
  
  var color : UXColor {
    set { self[dynamic: ColorEnvironmentKey.self] = newValue }
    get { self[dynamic: ColorEnvironmentKey.self] }
  }
  
  var todo : Todo {
    set { self[dynamic: TodoEnvironmentKey.self] = newValue }
    get { self[dynamic: TodoEnvironmentKey.self] }
  }
}
