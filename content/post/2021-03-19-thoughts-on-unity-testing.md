---
title: Thoughts on Unity Testing
author: Andrew Allbright
type: post
date: 2021-03-19T16:11:23+00:00
url: /thoughts-on-unity-testing/
categories:
  - Game Programming

---
Writing tests for software is important for multiple reasons. For me, testing increases velocity by removing the need for manual verification of a feature or bug fix. For me, testing takes on a form of documentation for my software. For me, testing lets me return to a project and get a little hit of dopamine as I see a set of passing tests.

Unity is a fantastic piece of software with an equally fantastic amount of warts. Those warts extend to testing. In my opinion, the developers of Unity consider testing a second class activity. In my opinion, the developers of Unity do not think their end users find value in testing. I believe the developers of Unity do not have their most highly talented engineers working on the testing story for Unity.

Building video games is challenging. Writing tests for video games is challenging as well. Part of the challenge for both activities is the shift in thinking required to create video games. Part of the challenge is artificial because of two key things: lack of vision by the developers of Unity and lack of quality, pragmatic information by Unity and the community at large.

First, lets talk about quality information. Coming from software engineering where there is plenty of documentation freely available, the lack of quality resources is suggestive. The lack of quality resources suggests to me that people who make video games considers their hard earned lessons a form of &#8220;trade secret&#8221; to be kept away from others. I wonder why? Is it fear? Is it to later sell this information for fame or money? As a consumer (and contributor) of the open source community, this philosophy is jarring to me.

Maybe you are a new to the Unity community and you&#8217;ve found channels on YouTube that (profess to) teach you about game development. In my experience, a majority suffer from the problem of trivial examples and the problem of wanting to create the facade of being an expert. The problem of trivial examples is self explanatory: the example is often a starting point to a starting point to a component for a game, with the core nuances left out. The problem with the facade is that, well, the creators aren&#8217;t actually _really_ writing video games. There are so many snake oil salespeople in this space&#8230;

Because testing is a niche topic, and because video game creation is another niche topic, good luck finding someone who has consolidated their knowledge of a quality test for mass consumption.

Second, I believe that the developers of Unity have not thought about the testing story for creators of Unity. Testing is very much a product feature, very much worth having a product owner imagining how to convert more people into testing. So why do I believe this is not the case?

It is not easy to begin writing a project&#8217;s first test in Unity. Knowledge of assemblies is required to configure your environment for tests. If you rely on testing doubles, knowledge of DLLs is required to add in third party dependencies (such as NSubstitute). This is a high bar of knowledge when most creators are simply used to writing C# scripts in the preconfigured environment unity provides when a new Unity project is created. Why is there so much friction in writing a test? Is there anything that can be done? Why isn&#8217;t there a testing double library baked into the default testing framework? Is it recommended to write tests without one?

Writing a test in Unity is confusing. This is a general problem in the software community in general, granted, and developers of Unity aren&#8217;t doing enough to help. For example, what is the difference between a edit mode test and a play mode test? What is the difference of **Test** and **UnityTest** in the two modes? When do you want to write a edit mode test versus a play mode test? What is the trade off? These are questions that can only be answered through the rugged, brutality of experience.

For me, my experience tells me to never write a play mode test. Play mode tests require that the game be playing, which requires anywhere from 10-45 seconds before your first test runs. Fast feedback is crucial and anything over 1-3 seconds is unacceptable for me.

Testing in Unity is both a pleasure and a curse. It is a pleasure for the reasons listed in my first paragraph. It is a curse because it is a very frustrating experience indeed to have to work through.

<hr class="wp-block-separator" />

P.S. To digress briefly to expand on the &#8220;smoke and mirrors&#8221; mentality, I believe a creator must think in &#8220;smoke and mirrors&#8221; in order to create something in a _reasonable_ amount of time. Sometimes the illusion is just as real as the real thing, especially if the illusion costs 100x less time to create. In my nascent opinion, this is the differentiator between those who can deliver their software and those who can&#8217;t