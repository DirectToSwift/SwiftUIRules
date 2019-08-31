//
//  SceneDelegate.swift
//  RulesTestApp
//
//  Created by Helge Heß on 30.08.19.
//  Copyright © 2019 ZeeZide GmbH. All rights reserved.
//

import UIKit
import class SwiftUI.UIHostingController

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions)
  {
    // Create the SwiftUI view that provides the window contents.
    let contentView = ContentView()

    // Use a UIHostingController as window root view controller.
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = UIHostingController(rootView: contentView)
      self.window = window
      window.makeKeyAndVisible()
    }
  }

  func sceneDidDisconnect      (_ scene: UIScene) {}
  func sceneDidBecomeActive    (_ scene: UIScene) {}
  func sceneWillResignActive   (_ scene: UIScene) {}
  func sceneWillEnterForeground(_ scene: UIScene) {}
  func sceneDidEnterBackground (_ scene: UIScene) {}
}
