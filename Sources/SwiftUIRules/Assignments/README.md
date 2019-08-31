<h2>SwiftUI Rule Assignments
  <img src="https://zeezide.com/img/SwiftUIRules/SwiftUIRulesIcon.svg"
       align="right" width="128" height="128" />
</h2>

The `RuleAction`, most commonly a `RuleAssignment` defines what gets executed when
a rule was selected for evaluation. 
If the rule was the best condidate for a given query, the framework will call the 
```swift
func fireInContext(_ context: RuleContext) -> Any?
```
method on the action.

Sample:
```swift
\.bannerColor <= "red"
\.bannerColor <= \.defaultColor
```

Note that the name `Action` does not imply that the object somehow modifies
state in the context, *it usually does not have any sideeffects*.
Instead the action just *returns* the value for a requested key by performing some
evaluation/calculation.

The most common assignments are:
- `RuleTypeIDAssignment`, return a constant value
- `RuleTypeIDPathAssignment`, return the value of another key
as shown in the sample above.

Note: There is a glitch in the current implementation which allows you to specify
full keypathes on the right hand side:
```swift
\.person.firstname <= "Mickey"
```
This does not currently work. Only keypathes pointing to `DynamicEnvironmentKeys`
will work.
