---
title: Techniques to Mitigate GameLift Anywhere’s Odd Delays
author: Andrew Allbright
type: post
date: 2024-05-28T11:39:13+00:00
url: /techniques-to-mitigate-gamelift-anywheres-odd-delays/
categories:
  - Game Programming

---
AWS GameLift is a cool product allowing game developers (hobbyist or professional) to develop multiplayer projects. You provide the game server executable and GameLift will take care of hosting the server processes, to your specifications. They even have a collection of features called &#8220;GameLift Anywhere&#8221; that supports a local development. Say you want to test some netcode you&#8217;ve written for your game, you&#8217;re using Unity, and you&#8217;ve already installed the GameLift unity plugin. Great! You can start your game server in your locally running Unity Editor and GameLift can know about the server there.

However; all is not well. Once you hit &#8220;play&#8221; it can take anywhere from 1 to 4 minutes, averaging around 2 and a half minutes before GameLift knows about your locally running server. No big deal, right?

Well for whatever reason it&#8217;s a big deal for me. I like to iterate and see changes frequently especially in earlier stages of development. Waiting sucks and knocks me out of my flow state. Your mileage may vary.

This article is meant to be some solutions to mitigate this undesirable (and undocumented) aspect of GameLift.

## Idea 1: A Banks of Local Game Server Processes {.wp-block-heading}

The idea is to containerize the game server process. It takes 1 to 4 minutes for each server process to be &#8220;seen&#8221; by GameLift. What if we pre-wait the wait by having a bank of game server processes managed by Docker Compose available.

This might be great for later stages of development when one is testing that a player can connect to game servers through GameLift.

It doesn&#8217;t work for early stages of development since one would ideally want clients connecting to the application running the Unity Editor. You can enable remote debugging though, if you want to. Its more complicated but if you haven&#8217;t learned how to remote debug an application in a container, its probably best you learn how.

## Idea 2: Using SAM, have a &#8220;Join&#8221; API just return local server locations without querying GameLift {.wp-block-heading}

Keeping with the &#8220;run locally before promoting to production&#8221; theme, what if we introduce an API that game clients interact with, instead of interacting with GameLift API directly. It&#8217;s not really a small request to stand up an API using SAM but it&#8217;s also not really a big deal either.

Once you&#8217;ve learned and understood AWS SAM, you can create APIs using

## Idea 3: Wait until GameLift removes delay {.wp-block-heading}

The cleanest and most intuitive use of GameLift is once a game server process is registered using the GameLift C# SDK inside the Unity Editor when running is that the game server process is _immediately_ seen by the GameLift system. Maybe I&#8217;m not the only person in the world that thinks this. Maybe someone from the GameLift development team agrees. Maybe its being worked on. Maybe we must simply wait.

This option reduces the amount of code built for the sole purpose of mitigating the system&#8217;s oddities. It also implies waiting.

## Conclusion {.wp-block-heading}

Waiting 1 to 4 minutes before testing one&#8217;s game project in the grand scheme of things probably isn&#8217;t that big of a deal. It may represent further delays. It might not, if you&#8217;re the kind of person who doesn&#8217;t mind it. Maybe you just multitask.

Ultimately, when we create software that interacts with 3rd party systems and those 3rd party systems have unusual behavior its up to us to work around the peculiarities.