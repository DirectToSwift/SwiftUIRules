//
//  RulingViews.swift
//  RulesTestApp-Mobile
//
//  Created by Helge Heß on 30.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

// Notice how `SwiftUIRules` is irrelevant to those views, they access the
// rule system as if it is an environment variable.
import SwiftUI

/**
 * This is a nonsensical view to demonstrate the rule system.
 *
 * It expects a `fancyColor` in the environment and will apply that to the
 * Text's foregroundColor.
 *
 * Now the trick is that the color can be generated using the rule system.
 */
struct ColoredText: View {
  
  var label : String
  
  @Environment(\.fancyColor) private var color
  
  var body: some View {
    Text(label)
      .foregroundColor(color)
  }
}

/**
 * This is a nonsensical view to demonstrate the rule system.
 *
 * This one expects a title from the environment, which again can be supplied
 * by the rule system.
 *
 * Notice how this one is only interested in the title. How this is colored
 * is transparent to the view itself.
 */
struct ColoredTitle: View {

  @Environment(\.title) private var title
  
  var body: some View {
    ColoredText(label: title)
  }

}
