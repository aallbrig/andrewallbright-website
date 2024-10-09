---
title: Trade-offs During Project Execution
author: Andrew Allbright
type: post
date: 2020-08-01T22:21:49+00:00
url: /hypocrisy-as-a-pragmatic-development-tool/
categories:
  - Software Engineering

---
<blockquote class="wp-block-quote is-layout-flow wp-block-quote-is-layout-flow">
  <p>
    Perfect is the enemy of good
  </p>
  
  <cite>Voltaire</cite>
</blockquote>

Programmers come up with rules constantly in an effort to make our products more resilient, the code easier to work with, or even to release. Sometimes these rules play well with each other but sometime these rules contradict. This creates a problem for the programmer &#8212; given a set of rules contradict each other, which one should the programmer follow?

This problem of conflicting rules is exacerbated when working with a group of other programmers on a common product. When making development decisions it is very easy to fall into the trap of violating at least one rule. Some software engineers make it their job of pointing each of these violations out and often, discussions will focus on how the group can rearrange code or decisions to ensure the violation is made right.

However; I have observed that this creates a new problem. Since programmers have so many rules that _should_ be followed every decision is like taking a step in quicksand. Every choice is contested and one can quickly become discouraged. An experienced programmer learns to question every decision themselves. Ultimately this may come at the cost of value output for the business. We may be able to get around this issue by using a cognitive technique. Enter hypocrisy.

The authors of [The Fundamentals of Software Architecture][1] talk about how every architecture choice is a trade off. When you decide to move forward you are sacrificing something to gain something else. In that context, one can argue that the perfect product that adheres to all rules programmers create for themselves is simply too expensive to create. We are all constrained by time or money and it is our duty to deliver value to our customers.

Maybe the code base doesn&#8217;t adhere to a trend and maybe the code base does indeed have _ugly_ code. It is hypocritical to say that, yes, this code base has these issues and maybe there are bugs that still need to be resolved, it is still shipping. Hypocrisy is allowing the group to make a trade off &#8212; deliver the code now to generate value for the business at the cost of generating tech debt.

The teams who ship are the teams who are best positioned to gain more. By using hypocrisy we can begin to undercut perfectionist conversations that get us into the trap of <a href="https://en.wikipedia.org/wiki/Analysis_paralysis" target="_blank" rel="noreferrer noopener">analysis paralysis</a>.

Next time you are in a technical conversation remember to weigh the trade off of obtaining perfection versus shipping code.

 [1]: https://www.amazon.com/gp/product/1492043451/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=1492043451&linkCode=as2&tag=allbright-20&linkId=ec5080a33c310dc08f734256492c7352