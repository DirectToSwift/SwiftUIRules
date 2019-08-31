<h2>SwiftUI Rule Predicates
  <img src="https://zeezide.com/img/SwiftUIRules/SwiftUIRulesIcon.svg"
       align="right" width="128" height="128" />
</h2>

The predicate defines whether a rule is active for a given context. For
example if a rule has such a qualifier:

```swift
\.user.role == "Manager"
```

It will only be considered for evaluation if the current user has a Manager
role.

The key method which all rule predicates implement is:

```swift
func evaluate(in ruleContext: RuleContext) -> Bool
```

It just returns true or false depending on whether the predicate matches for the
given `ruleContext`.

### Predicate Complexity

Another `RulePredicate` property is `rulePredicateComplexity`, which defaults to 1.

The complexity is used to sort predicates based on how many components
or relevance a predicate has. It is used to disambiguate in situations
like:

```swift
\.person.name == "Duck"                        => \.title <= "Donald"
\.task == "show" && \.person.name == "Persons" => \.title <= "Brummel"
```

In this case the second rule is checked first, because the predicate
has more components (and hence assumed significance).

### KeyPath Predicate

This is the most common predicate, it takes a keypath and a matching value:

```swift
\.person.name == "Duck"
```

When it is evaluated, it resolves the keypath against the ruleContext and returns
whether the value matches the constant passed into the predicate.

### Compound Predicates

The usual AND, OR and NOT predicates. Can be constructed using the
`&&`, `||` and `!` operators.

```swift
\.person.name == "Duck" && !(\.person.category == "VIP")
```
