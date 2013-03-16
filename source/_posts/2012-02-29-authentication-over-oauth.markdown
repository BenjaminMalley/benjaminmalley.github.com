---
layout: post
title: "Authentication over OAuth"
date: 2012-02-29 03:29
comments: true
categories: 
---

Authorization via OAuth is a really great idea. Properly implemented, it provides adequate security in a way that's mostly seamless to users. Authentication via OAuth, on the other hand, is a really, really bad idea. Properly implemented, it encourages insecure behavior on the part of users and opens the door to malicious attacks.

Now, to be clear, I understand that OAuth doesn't actually handle authentication. But commonplace implementations of it allow users to authenticate in the context of an OAuth authorization. If a user wants to allow application A to access resources hosted by application B, they follow a link on A and authenticate to a login form C (supposedly hosted by C). The problem here is that some malicious entity could operate both A and C, presenting C as if it were hosted by B and collect user credentials all the live long day. Of course, OAuth pages are validated by HTTPS and CAs to prevent this kind of attack, but never mind this because users almost certainly won't.

To check this problem out for myself, I mocked up my own little web app which does nothing except pretend to authenticate to Facebook via OAuth. Then I got some people I knew to enter their passwords into the web form I provided by pretending I wanted to demo something I was working on.  Did the fact that I knew these people influence the likelihood that they would enter their credentials into my form? Undoubtedly. However, even if there is never a single successful OAuth phishing attempt in the wild (which I highly doubt), it's still broken because a) it squanders inherent security advantages of the platforms it's meant to protect and b) it encourages unsafe behavior on the part of users.

Facebook, Twitter et al have great inherent phishing protection because users' homepages contain a great deal of personal information and are thus hard to replicate. Online banking services try to accomplish something similar by presenting users with a shared secret image or phrase at login so users know they're logging into the correct site. Same idea, but less good because it's much harder to remember to check for the inclusion of, say, the picture of the tree you picked out back when you created your account than it is to see if your friends are still the same people they always were and they're still providing reasonable status updates.

One consequence of this is that if a user is attempting to log into Facebook and has been phished, he or she is more likely to know right away.  Knowledge that one's credentials have been compromised, while less good than not having one's credentials compromised in the first place, is still leagues better than lack of awareness. But by shifting authentication to a special OAuth page, or worse, overlay, users aren't redirected to their home page after a successful login, thus the advantage is squandered and the likelihood is increased that a user's credentials can be compromised without his or her knowledge.

But even that really doesn't get to the heart of it. Authentication over OAuth is bad because it actively encourages unsafe practices. Users don't know what OAuth is. They don't care. The user experience of OAuth is divorced from the implementation. Once it becomes normative to input one's credentials in special authorization overlays, that's what users will do, regardless of the whether the underlying mechanism is OAuth or plain text over HTTP.

Services that implement authentication through OAuth are doing a disservice to their users. Instead of taking advantage of the opportunity to educate users about security and improving the safety of the web for everyone, services that implement authentication over OAuth are punting, and choosing convenience over security.

Fortunately, the remedy for this problem is simple: don't allow your users to authenticate through OAuth. Just don't do it. Authentication over OAuth is not fundamental to the service and can easily be replaced by a nice, user friendly message.  Something like this:

*Service X doesn't recognize you. This isn't a big deal, it probably
just means you're not currently logged in. If you want to authorize this
application to access your Service X account, head on over to
ServiceX.com and log into your account. Then try the authorization
process again.*

Yes, from a UX perspective this message is less convenient than providing a log in form, but I have a hard time imaging any user experience that's worse than having one's account stolen.
