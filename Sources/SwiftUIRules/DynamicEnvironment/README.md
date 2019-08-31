<h2>SwiftUI Dynamic Environment Keys
  <img src="https://zeezide.com/img/SwiftUIRules/SwiftUIRulesIcon.svg"
       align="right" width="128" height="128" />
</h2>

"Environment Keys" are keys which you can use like so in SwiftUI:

```swift
public struct MyView: View {

  @Environment(\.database) private var database // retrieve a key

  var body: some View {
    BlaBlub()
      .environment(\.database, database) // set a key
  }
}
```

They are scoped along the view hierarchy.

`DynamicEnvironmentKeys` are the similar, but can resolve to different values on
demand.

For example a rule system could evaluate them like so:

    day  < 28 => color = green
    day >= 28 => color = red
    *true*    => color = white

But they don't have the be backed by a rule system.
`DynamicEnvironmentKey` and `DynamicEnvironmentValues` 
just form an API to back such keys.


### Implementation

While the `DynamicEnvironmentKey` forms a statically typed interface,
the actual dynamic workings are defined in terms of the `ObjectIdentifier`s
of those types.
For various reasons :-)


### Allow arbitrary Environment Keys

It might make sense to allow lookup of any environment key, not just dynamic ones.
TBD.
