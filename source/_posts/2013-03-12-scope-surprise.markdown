---
layout: post
title: "Scope surprise"
date: 2013-03-12 21:45
comments: true
categories: 
---
Try this little Python quiz. Given, the following Python code

``` python
test = [(lambda: i) for i in range(1, 10)]
```

what do you think the value of <code>test\[0\]()</code> is?

Did you say 1? Guess again. The answer is 9. In fact, the answer does not change no matter what index you call in the test list--it's always 9.

If this surprises you, it may be because, well, it's a little surprising. But surprising or not, it perfectly valid when evaluated against Python's scoping rules. Python defines scope in terms of three distinct blocks: a module, a function and a class definition.  Straight from the language reference:

When a name is used in a code block, it is resolved using the nearest enclosing scope. The set of all such scopes visible to a code block is called the block's environment.

List comprehensions, for loops and if-else statements do not introduce new blocks and therefore do not introduce new scopes. Thus, when the lambda is called, it looks up i in the current environment and discovers that its value is now nine.

Because function bodies *do* introduce new scopes, you can of course "resolve" this issue by creating a closure around the lambda like so

``` python
test = [(lambda x: (lambda: x))(i) for i in range(1,10)]
```

Of course, you should not write this code in Python.
