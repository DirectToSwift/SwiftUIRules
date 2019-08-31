//
//  Model.swift
//  RulesTestApp-Mobile
//
//  Created by Helge Heß on 30.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

enum Priority {
  case low, normal, high
}

struct Todo {
  var title     : String
  var completed : Bool
  var priority  : Priority
}

extension Todo {
  static let buyBeer =
    Todo(title: "Buy beer", completed: false, priority: .high)

  static let cleanFlat =
    Todo(title: "Clean flat", completed: false, priority: .low)
}
