//
//  TodoView.swift
//  RulesTestApp-Mobile
//
//  Created by Helge Heß on 30.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

import SwiftUI
import SwiftUIRules

struct MainView: View {
  
  let ruleContext = RuleContext(ruleModel: ruleModel)
  
  var body: some View {
    VStack {
      ColoredTitle()
        .environment(\.priority, .high)
        .font(.title)

      Spacer()
      
      TodoView()
        .environment(\.todo, .buyBeer) // make todo available to rulesystem
      TodoView()
        .environment(\.todo, .cleanFlat)

      Spacer()
    }
    .environment(\.ruleContext, ruleContext)
      // here we inject our ruling context into all child views
  }
  
}

struct TodoView: View {
  
  // Note: This doesn't even know about the todo
  
  var body: some View {
    VStack {
      Text("My todo:")

      ColoredTitle()
        .font(.title)
    }
  }
}
