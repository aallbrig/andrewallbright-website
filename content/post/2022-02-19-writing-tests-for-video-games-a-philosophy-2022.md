---
title: 'Writing Tests for Video Games: A Philosophy (2022)'
author: Andrew Allbright
type: post
date: 2022-02-19T16:30:40+00:00
url: /writing-tests-for-video-games-a-philosophy-2022/
categories:
  - Game Programming

---
I mean to capture my current early 2022 thoughts on writing tests intended to be run by <a href="https://game.ci/docs" target="_blank" rel="noreferrer noopener">automated processes</a> created for Unity based video games. I want to capture my thoughts so I can share this and receive feedback. I _know_ I haven&#8217;t found a holistic philosophy around testing. I _know_ I can be better. If you can help, please do!

### Pit stop: Where is all the content? {#pit-stop-where-is-all-the-content.wp-block-heading}

I love researching topics, buying books, and seeing what content &#8220;influencers&#8221; say on topics. When I investigate this topic I find very little content. Are content creators disinterested in this topic? The ones that do create content seem to be stuck showing testing setup and trivial examples, such as testing a function that adds two numbers. I&#8217;m sure there is a deep dive out there but I can&#8217;t seem to find it.

There is hope. Someone shared this high quality Unity talk where they discuss how they structured their code to support testing, and why that&#8217;s important.<figure class="wp-block-embed is-type-video is-provider-youtube wp-block-embed-youtube wp-embed-aspect-16-9 wp-has-aspect-ratio">

<div class="wp-block-embed__wrapper">
</div><figcaption>What a breath of fresh air</figcaption></figure> 

My conclusion is that testing is just a subject that requires more thought and consideration from the community.

With the help of books like **<a rel="noreferrer noopener" href="https://amzn.to/3I5QzsC" target="_blank">Unit Testing: Principles, Practices, and Patterns</a>**, **<a rel="noreferrer noopener" href="https://amzn.to/34NTmbM" target="_blank">Growing Object Oriented Software Guided by Tests</a>**, and **<a rel="noreferrer noopener" href="https://amzn.to/3s0kFrP" target="_blank">Dependency Injection: Principles, Practices, and Patterns</a>** I have synthesized my own nascent testing philosophy for unity.

### Does it even make sense to write tests for video games? {#does-it-even-make-sense-to-write-tests-for-video-games.wp-block-heading}

For me the answer is &#8220;yes.&#8221; I typically share this short blog from an EA employee: <a rel="noreferrer noopener" href="https://devtails.xyz/3-lines-of-code-shouldnt-take-all-day" target="_blank">3 Lines of Code Shouldn&#8217;t Take All Day</a>

The answer for you may be &#8220;no&#8221; and I think that&#8217;s just fine. I truly see merits in the styles of thinking that lead to &#8220;yes&#8221; and that lead to &#8220;no.&#8221; I think both answers stem from valid worldviews.

Do. What. Works. For. You.

## Types of Testing {#types-of-testing.wp-block-heading}

In Unity there are _many_ types of code one can write. Right now I simplify by declaring four types of code. Attachable components derive from the familiar **<a rel="noreferrer noopener" href="https://docs.unity3d.com/ScriptReference/MonoBehaviour.html" target="_blank">MonoBehaviour</a>** (MB). Custom project assets are defined by **<a rel="noreferrer noopener" href="https://docs.unity3d.com/Manual/class-ScriptableObject.html" target="_blank">ScriptableObject</a>**s (SO) and typically work in tandem with MBs. Editor scripts derive from <a rel="noreferrer noopener" href="https://docs.unity3d.com/ScriptReference/Editor.html" target="_blank">Editor</a>. The humble **vanilla C# code** serve as a way of modeling a solution space outside of the Unity game engine.

The <a rel="noreferrer noopener" href="https://docs.unity3d.com/Packages/com.unity.test-framework@1.1/manual/index.html" target="_blank">Unity Test Framework</a> affords a matrix of four types of test suites. First, one must decide if a test is an **Edit Mode** test or a **Play Mode** test. Afterwards, one must decide if the test they are writing requires an asynchronous execution context (`[UnityTest]`) or a synchronous one (`[Test]`). _Note: the unity test framework 2.0 consolidates Edit Mode and Play Mode testing and leverages attributes instead to make the same types of declaration as above._

<ul class="wp-block-list">
  <li>
    Synchronous edit mode tests are the fastest suite
  </li>
  <li>
    Asynchronous edit mode tests are slightly slower
  </li>
  <li>
    Synchronous and asynchronous play mode tests are the slowest option but allows the Unity game engine to execute lifecycle methods
  </li>
</ul>

### Unit Tests {#unit-tests.wp-block-heading}

Vanilla C# code gets to leverage edit mode tests. A tester has full control over the construction and function calls.

**Editor** tests are tests that require the `[UnityTest]` attribute but can still be run as an Edit Mode test. I honestly haven&#8217;t written enough editor scripts to have an example test for them.

I have learned not to fight and to just add **MonoBehaviour** and **ScriptableObject** as Play Mode tests. This allows the Unity engine to call all relevant lifecycle methods. You can do this yourself by making `private` methods into `public` ones but&#8230; Been there, there be dragons, and no thanks.

Another &#8220;gotcha&#8221; that I learned to appreciate is the **<a rel="noreferrer noopener" href="https://docs.unity3d.com/Manual/ExecutionOrder.html" target="_blank">Order of Execution</a>** for the unity class lifecycle methods. Basically, if you want to ensure your `Awake` or `Start` methods are called, you need to wait a frame. I usually `yield return null` or `yield return new WaitForEndOfFrame()` to wait a frame.

Anyways, since this is a unit test I usually create a `new GameObject` and `AddComponent` to add the MB I want to test. I save the conceptualization of a Game Object as a means of dependency injection and service locator for another time.

Here is an example ScriptableObject test.

### Integration Tests {#integration-tests.wp-block-heading}

This is where I think I have some interesting insight. I think prefabs serve as a perfect unit for integration testing. I like to instantiate an instance of a prefab and write tests against prefabs that describe higher level behavior. For example, here is a test where I assert that this &#8220;player&#8221; prefab can be moved by input from the new unity input system.

At this time, I have not written a unity project that collaborates with external systems. When I do I plan on using abstract interface techniques to hide the collaboration with the external system in a way that I can mock out that collaboration. To avoid a leaky layer of abstraction I will return my own domain objects instead of responses directly from whatever system I am collaborating with.

### Acceptance Testing {#acceptance-testing.wp-block-heading}

Unity Scenes serve as the level I want to write tests. Right now I typically ensure expected game objects exist within the scene and hope that the lower level tests have ensured a certain behavior of game entities.

## Conclusion {#conclusion.wp-block-heading}

I&#8217;m still figuring it out. I&#8217;m sure the type of content I hope for is it out. However; I&#8217;m perfectly okay figuring out my own strategy. If you have any input or suggestions, I would appreciate receiving feedback. Thank you in advance!

I hope some found this content interesting.