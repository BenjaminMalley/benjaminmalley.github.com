---
layout: page
title: "en route: A trip-based location sharing app"
comments: true
sharing: true
footer: true
---
{% img right /images/enroute.png %}

I am currently developing *en route*, a web application for trip-based location sharing. This app solves a problem that I commonly have: being able to share my location with others without having to use my phone. This is useful, for example, when I'm picking someone up at the airport.

There are other apps that do similar things (Find My Friends, etc.), but *en route* differs from all of them because it is based around trips: you tell it where you're going and it tracks your location until you get there, then it automatically stops tracking you.

This app is based around Google Maps (which it uses for routing) and Twitter (which it uses for location sharing), though I am planning on adopting additional mechanisms for sharing.

To build *en route*, I started by talking with people I knew about the kinds of use cases I envisioned. From these discussions, I developed a set of personas and scenarios. Then I made some wireframes and conducted user testing, before building out a functional HTML5 prototype which is hosted [here](enroute.herokuapp.com). I am currently developing a more fully featured Android version of the application.

On the tech side: *en route* is built with using the Flask framework and Redis on the backend and a minimal HTML5/jQuery front end.
 
**Skills: user research, prototyping, web development, market research**