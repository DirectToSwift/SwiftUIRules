<h2>SwiftUI Rules
  <img src="https://zeezide.com/img/SwiftUIRules/SwiftUIRulesIcon.svg"
       align="right" width="128" height="128" />
</h2>

![Swift5.1](https://img.shields.io/badge/swift-5.1-blue.svg)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![iOS](https://img.shields.io/badge/os-iOS-green.svg?style=flat)
![watchOS](https://img.shields.io/badge/os-watchOS-green.svg?style=flat)
![Travis](https://api.travis-ci.org/DirectToSwiftUI/SwiftUIRules.svg?branch=master&style=flat)

_Going fully declarative_: SwiftUI Rules.

SwiftUI Rules is covered in the companion AlwaysRightInstitute
blog post:
[Dynamic Environments ¶ SwiftUI Rules](http://www.alwaysrightinstitute.com/swiftuirules/).

## Requirements

SwiftUI Rules requires an environment capable to run SwiftUI.
That is: macOS Catalina, iOS 13 or watchOS 6.
In combination w/ Xcode 11.

Note that you can run iOS 13/watchOS 6 apps on Mojave in the emulator,
so that is fine as well.

## Using the Package

You can either just drag the SwiftUIRules Xcode project into your own
project,
or you can use Swift Package Manager.

The package URL is:
[https://github.com/DirectToSwiftUI/SwiftUIRules.git
](https://github.com/DirectToSwiftUI/SwiftUIRules.git).

## Using SwiftUI Rules

SwiftUI Rules is covered in the companion AlwaysRightInstitute
blog post:
[Dynamic Environments ¶ SwiftUI Rules](http://www.alwaysrightinstitute.com/swiftuirules/).

### Declaring Own Environment Keys

Let's say we want to add an own
environment key called `fancyColor`.

First thing we need is an 
[`DynamicEnvironmentKey`](https://github.com/DirectToSwiftUI/SwiftUIRules/blob/develop/Sources/SwiftUIRules/DynamicEnvironment/DynamicEnvironmentKey.swift#L17) 
declaration:
```swift
struct FancyColorEnvironmentKey: DynamicEnvironmentKey {
  public static let defaultValue = Color.black
}
```
Most importantly this specifies the static Swift type of the environment key
(`Color`)
and it provides a default value.
That value is used when the environment key is queried, 
but no value has been explicitly set by the user.

Second we need to declare a property on the
[DynamicEnvironmentPathes](https://github.com/DirectToSwiftUI/SwiftUIRules/blob/develop/Sources/SwiftUIRules/DynamicEnvironment/DynamicEnvironmentPathes.swift#L19)
struct:
```swift
extension DynamicEnvironmentPathes {
  var fancyColor : Color {
    set { self[dynamic: FancyColorEnvironmentKey.self] = newValue }
    get { self[dynamic: FancyColorEnvironmentKey.self] }
  }
}
```
That's it. We can start using our new key.

Some View accessing our splendid new `fancyColor`
using the 
[@Environment](https://developer.apple.com/documentation/swiftui/environment)
property wrapper:
```swift
struct FancyText: View {
  
  @Environment(\.fancyColor) private var color
  
  var label : String
  
  var body: some View {
    Text(label)
      .foregroundColor(color) // boooring
  }
}
```
and a View providing it:

```swift
struct MyPage: View {
  
  var body: some View {
    VStack {
      Text("Hello")
      FancyText("World")
    }
    .environment(\.fancyColor, .red)
  }
}
```

### Setting Up a Ruling Environment

We recommend creating a `RuleModel.swift` Swift file. Put all your
rules in that central location:
```swift
// RuleModel.swift
import SwiftUIRules

let ruleModel : RuleModel = [
  \.priority == .low    => \.fancyColor <= .gray,
  \.priority == .high   => \.fancyColor <= .red,
  \.priority == .normal => \.fancyColor <= .black
]
```

You can hookup the rule system at any place in the SwiftUI View hierarchy,
but we again recommend to do that at the very top.
For example in a fresh application generated in Xcode, you could modify
the generated `ContentView` like so:
```swift
struct ContentView: View {
  private let ruleContext = RuleContext(ruleModel: ruleModel)
  
  var body: some View {
    Group {
      // your views
    }
    .environment(\.ruleContext, ruleContext)
  }
}
```

Quite often some “root” properties need to be injected:
```swift
struct TodoList: View {
  let todos: [ Todo ]
  
  var body: someView {
    VStack {
      Text("Todos:")
      ForEach(todos) { todo in
        TodoView()
           // make todo available to the rule system
          .environment(\.todo, todo)
      }
    }
  }
}
```
`TodoView` and child views of that can now derive environment values of
the `todo` key using the rule system.

### Use Cases

Ha! Endless 🤓 It is quite different to “Think In Rules”™
(a.k.a. declaratively),
but they allow you to compose your application in a highly decoupled
and actually “declarative” ways.

It can be used low level, kinda like CSS. 
Consider dynamic environment keys a little like CSS classes.
E.g. you could switch settings based on the platform:
```swift
[
  \.platform == "watch" => \.details <= "minimal",
  \.platform == "phone" => \.details <= "regular",
  \.platform == "mac" || \.platform == "pad" 
  => \.details <= "high"
]
```

But it can also be used at a very high level,
for example in a workflow system:
```swift
[
  \.task.status == "done"    => \.view <= TaskFinishedView(),
  \.task.status == "done"    => \.actions <= [],
  \.task.status == "created" => \.view <= NewTaskView(),
  \.task.status == "created" => \.actions = [ .accept, .reject ]
]

struct TaskView: View {
  @Environment(\.view) var body // body derived from rules
}
```

Since SwiftUI Views are also just lightweight structs,
you can build dynamic properties which carry them!

In any case: We are interested in any idea how to use it!


### Limitations

#### Only `DynamicEnvironmentKey`s

Currently rules can only evaluate `DynamicEnvironmentKey`s,
it doesn't take regular environment keys into account.
That is, you can't drive for example the builtin SwiftUI `lineLimit`
using the rulesystem.
```swift
[
  \.user.status == "VIP" => \.lineLimit <= 10,
  \.lineLimit <= 2
]
```
**Does not work**. This is currently made explicit by requiring keys which
are used w/ the system to have the `DynamicEnvironmentKey` type.
SO you can't accidentially run into this.

We may open it up to any `EnvironmentKey`, TBD.

#### No KeyPath'es in Assignments

Sometimes one might want this:
```swift
\.todos.count > 10 => \.person.status <= "VIP"
```
I.e. assign a value to a multi component keypath (`\.person.status`).
That **does not work**.

#### SwiftUI Bugs

Sometimes SwiftUI “looses” its environment during navigation or in List's.
watchOS and macOS seem to be particularily problematic, iOS less so.
If that happens, one can pass on the `ruleContext` manually:
```swift
struct MyNavLink<Destination, Content>: View {
  @Environment(\.ruleContext) var ruleContext
  ...
  var body: someView {
    NavLink(destination: destination
      // Explicitly pass along:
      .environment(\.ruleContext, ruleContext)) 
  ...
}
```


## Who

Brought to you by
[The Always Right Institute](http://www.alwaysrightinstitute.com)
and
[ZeeZide](http://zeezide.de).
We like
[feedback](https://twitter.com/ar_institute),
GitHub stars,
cool [contract work](http://zeezide.com/en/services/services.html),
presumably any form of praise you can think of.
