---
layout: post
title: "Implementing Clojure's atoms in Python" 
date: 2012-06-22 20:13
comments: true
categories: 
---
I've long been a fan of Python, but I've recently been getting into Clojure and especially digging the concurrency features. Even though Python's not quite as strong in the concurrency department, I figured it would be relatively easy to implement something like Clojure's atoms in Python. And I was right, for the most part.

For the uninitiated, atoms are Clojure's synchronous, uncoordinated reference type. Atoms are created with the atom macro (ie. (def a (atom 0))) and modified with swap!. (swap! a fn), for example, applies the function fn to the current value of the atom a and updates a to the return value of the function. Easy, right? (This is why Clojure is so cool.)

This isn't difficult to do in Python. Here's how I did it:

``` python
def atom(val):
    from threading import Lock
    lock = Lock()
    value = val
  
    def swap(fn):
        lock.acquire()
        nonlocal value
        try:
            value = fn(value)
            return value
        finally:
            lock.release()
   
    return swap
```

The atom function sets the initial value of the atom and returns the swap function, which, in turn, takes a function as an argument and updates the atom's value by setting the value to function(value). The lock provides thread safety. Note the presence of the nonlocal keyword, which means this is Python 3 only (Python 2 closures allow only read access to outer scope variables, not write access. Urg!).

With this approach, the return value of atom() is the swap! function for the atom it defines. Therefore, swap! is invoked by calling the return value with the updating function like so:

``` python
a = atom(0)
a(lambda x: x + 1)
```

In Clojure, atoms are dereferenced with a special dereferencing operator, @. We don't have any cool tricks like that in Python. Instead, the current value of the atom is returned by the identity function:

``` python
a(lambda x: x)
```

Other than that, it pretty much works as expected.

So here's where the frustration set in. Experienced Pythonistas are doubtless aware of the limitations of Python's threading implementation imposed by the Global Interpreter Lock. The Python documentation specifically states: If you want your application to make better of use of the computational resources of multi-core machines, you are advised to use multiprocessing. Multiprocessing, of course, supports the same primitives as threading, which means that in most cases, multiprocessing can be substituted for threading without major adjustments.
There is, however, one difference between threading and multiprocessing which renders my fun atom implementation useless. Multiprocessing uses pickle to serialize objects and share them between processes and unbound methods (i.e., our swap function) are not serializable.

Therefore, while this works just fine:

``` python
from concurrent.futures import ThreadPoolExecutor
import time
a = atom([1])

def add(x):
    time.sleep(1)
    return x + x

with ThreadPoolExecutor(max_workers=10) as e:
    for i in range(0, 10):
        e.submit(a, add)

    print(a(lambda x: x))
```

Doing the same thing with a ProcessPoolExecutor throws an exception. I'd
really like to be able to use this implementation with processes, but I
haven't come up with a good solution yet. Sometimes, in life as in
Python, it's better to just use objects and call it a day.
