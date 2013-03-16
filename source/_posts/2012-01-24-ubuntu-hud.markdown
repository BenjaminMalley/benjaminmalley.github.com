---
layout: post
title: "Ubuntu HUD"
date: 2012-01-24 20:37
comments: true
categories: 
---
Today Mark Shuttleworth introduced what he's calling "the future of the
menu" -- at least for Ubuntu, I guess. It's called HUD and it's a
text-based interface to supplement (replace?) application menus.
Text-based interfaces are always interesting. They're great because they
are fast and efficient for expert users and bad because they are really,
really slow and inefficient for novices. These days designers typically
eschew them in favor of GUI because targeting interfaces to expert users
is a pretty good way to lose users.

Though HUD is text-based, there's reason to be optimistic about its
suitability for the computing public.  This is because it functions more
like web search than a traditional command line interface, inserting a
results evaluation step in between input and execution. Typing a command
yields a nice dropdown menu of results matching a given input from which
the user can select the "best" match. This is a good thing.

With one glaring exception, this gives HUD a real discoverability
advantage over a GUI. If one wanted to discover whether a traditional
GUI application supported a "transform" function, one would need to scan
the menu items one by one or resort to some form of help. With HUD, the
user can type the name of the desired action and scan the results. As a
bonus, where the time needed to scan GUI menus increases as a function
of the number of menu items, HUD suffers from no such problem.

The glaring exception is that in order to use HUD successfully, users
must first identify the correct name of the function they wish to
invoke. If a user types "resize" instead of "transform" how will HUD
know what that user is intending to do? GUI menus are better here
because, although they are slow to scan, they can provide users with a
list of possibilities which users match against their goals.

At Adobe, we saw this first hand while observing users searching the web
to solve problems with graphic design software: users used the search
terms that didn't match the application vocabulary and got unhelpful
search results. After getting nothing from search, they returned to the
interface and began scanning it to help identify new search terms.  HUD
is actually worse than web search, because if you watch the video, it's
clearly matching program commands letter by letter, whereas Google
employs robust information retrieval and attempts, at least, to match
documents to more abstract "information needs."

This is a real problem, but one I think Ubuntu could fix. If someone is
using HUD, we know a lot more about their intent than if they're
searching the web. We know what program they're using and something
about the state of that program.  That's a lot, especially considering a
typical GUI application has relatively few functions accessible at any
one time.

What I envision is something like this: a function that maps a user
query to a program action by inferring user intent. So basically, less
grep, more Google.  Imagine two components: 1) a synonym list with
probability distributions for various program actions (HUD displays the
actions from highest to lowest probability) and 2) a voluntary analytics
program that tracks users to update the probabilities in (1).

HUD is a cool idea, but in its current form, I have a hard time
envisioning it working well for most people.  The vocabulary problem is
real and it's not going away.  If HUD can fix this, I think it could be
something special.
