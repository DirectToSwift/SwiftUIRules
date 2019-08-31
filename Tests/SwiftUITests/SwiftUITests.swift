//
//  SwiftUITests.swift
//  SwiftUITests
//
//  Created by Helge Heß on 30.08.19.
//

import XCTest
@testable import SwiftUIRules

class SwiftUITests: XCTestCase {
  
  func testSimpleModelDefaultEnvironment() throws {
    let context = RuleContext(ruleModel: [
      \.verb == "view" => \.title <= "Hello!"
    ])
    XCTAssertEqual(context.title, "Hello!")
  }

  func testSimpleModelCustomEnvironment() throws {
    var context = RuleContext(ruleModel: [
      \.verb == "edit" => \.title <= "Work it.",
      \.verb == "view" => \.title <= "Hello!"
    ])
    context.verb = "edit"
    
    XCTAssertEqual(context.title, "Work it.")
  }

  func testPathCompare() throws {
    let context = RuleContext(ruleModel: [
      \.todo.priority == .low  => \.color <= .gray,
      \.todo.priority == .high => \.color <= .red
    ])
    XCTAssertEqual(context.color, .red)
  }
  
  func testRuleComplexity() throws {
    let context = RuleContext(ruleModel: [
      \.todo.priority == .high                     => \.color <= .red,
      \.todo.priority == .high && \.verb == "view" => \.color <= .gray
    ])
    XCTAssertEqual(context.color, .gray)
  }
  
  func testSimplePathAssignment() throws {
    let context = RuleContext(ruleModel: [ \.navigationBarTitle <= \.title ])
    XCTAssertEqual(context.navigationBarTitle, TitleEnvironmentKey.defaultValue)
  }

  func testOtherPathAssignment() throws {
    let context = RuleContext(ruleModel: [ \.title <= \.verb ])
    XCTAssertEqual(context.title, VerbEnvironmentKey.defaultValue)
  }

  func testNestedPathAssignment() throws {
    let context = RuleContext(ruleModel: [
      \.navigationBarTitle <= \.title,
      \.title              <= \.verb
    ])
    XCTAssertEqual(context.title,              VerbEnvironmentKey.defaultValue)
    XCTAssertEqual(context.navigationBarTitle, VerbEnvironmentKey.defaultValue)
  }
  
  func testKeyPath2Predicate() throws {
    var context = RuleContext(ruleModel: [
      \.title == \.navigationBarTitle => \.color <= .red,
      \.color <= .green
    ])
    context.title              = "blub"
    context.navigationBarTitle = "blub"
    XCTAssertEqual(context.color, .red)
  }
  
  func CRASHtestSelfAssignment() throws {
    // This results in a regular recursion. It looks like it doesn't make
    // too much sense to protect against such simple ones, as the user can
    // always build recursions by other means.
    // We'd have to count the recursion in the context somehow and eventually
    // stop.
    let context = RuleContext(ruleModel: [
      \.title <= \.title
    ])
    _ = context.title
  }
}
