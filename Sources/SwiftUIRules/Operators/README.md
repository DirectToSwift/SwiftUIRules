#  SwiftUI Rules Operators

Not a huge fan of operator overloading, but well :-)

A set of operators to build rule predicates, assignments and rules.

Rule Predicate samples:
```swift
\.count       <  10
\.person.name == "Duck"
```

Rule Assignment samples:
```swift
\.title <= "1337"
\.title <= \.defaultTitle
```

Rule samples:
```swift
\.count > 5                            => \.color <= .red
\.count > 5 && \.person.name == "Duck" => \.color <= \.defaultColor
```
