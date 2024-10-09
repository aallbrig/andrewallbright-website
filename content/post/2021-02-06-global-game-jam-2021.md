---
title: Global Game Jam 2021
author: Andrew Allbright
type: post
date: 2021-02-06T14:02:36+00:00
url: /global-game-jam-2021/
categories:
  - Game Programming

---
Last weekend, the weekend of January 30th, I participated in <a rel="noreferrer noopener" href="https://globalgamejam.org/" target="_blank">Global Game Jam 2021</a>. I had not planned on participating because I was unaware of the details of the event. Having gone through the <a rel="noreferrer noopener" href="https://learn.unity.com/pathway/unity-essentials" target="_blank">Unity Essentials Pathway</a> I am aware of a few game jams and am aware that the global game jam is the largest of the bunch.

I see a post on Facebook from a former professor talking about how satisfied he felt participating with a group of students in Global Game Jam 2018. He provided the programming expertise to breath life and context into creatures and an environment created by students. I see this post and look up the game called <a rel="noreferrer noopener" href="https://globalgamejam.org/2018/games/r-e-l-y" target="_blank">Relay</a>. I&#8217;m impressed. I imagine the spark of joy felt by participants when everyone sees the result of the game jam. Bugs? That comes with the format of the event &#8212; 48 hours to create, from scratch, a game. I quickly find information on Global Game Jam 2021 during this search for the 2018 game. It started Wednesday the 27th when the idea was released (accidentally?) along with a keynote.

Late December, I began learning Unity in earnest. Could I really put something together in a weekend? I just began learning about the zen of Scriptable Objects. I make a deal with myself: rebuild the ability system of an Active Time Battle prototype in Scriptable Objects and decide to participate after. This is Friday the 29th. Now it is 3 A.M. in the morning and I&#8217;ve successfully done this. <a rel="noreferrer noopener" href="https://play.unity.com/mg/other/atb-v0-6-0" target="_blank">You can see it here</a>.

I begin Global Game Jam 2021 around 1 P.M. Saturday January 30th. I sign up on the jam website. I find the &#8220;jam site&#8221; for <a rel="noreferrer noopener" href="https://globalgamejam.org/2021/jam-sites/iupui-indianapolis" data-type="URL" data-id="https://globalgamejam.org/2021/jam-sites/iupui-indianapolis" target="_blank">my location</a>. I sign in to the discord server that is associated with the jam site and then get started on my own game.

My wife provides the idea I run with. The theme is lost and found. Her idea is to collect lost blockbuster videos and return them. I like the idea because it&#8217;s simple and the choice of blockbuster could be interesting. I decide to target WebGL so I can share the game over the web to reduce friction.

I implement a finite state machine for game states &#8220;Start Menu,&#8221; &#8220;Game Running,&#8221; and &#8220;Game Over.&#8221; I implement Scriptable Object events and event listeners to trigger state changes for this state machine.

I build UI by creating a canvas and placing a couple auto expanding color images, adding a margin to the &#8220;inner&#8221; (top?) image to create the illusion of a border. I create ColorVar Scriptable Objects to store color variables for the background and foreground UI image, and build a MonoBehaviour to always update the color. This lets me update the color of the UI at runtime. Cool!

I like unity nav mesh + nav mesh agents because I often fantasize about building an RTS game and this technology seem to be the best fit. I create an simple environment, bake a nav mesh, create an agent, and put together a script to move an agent to the other end of the environment. Player control is a secondary concern for now.

There are a few elements to my game. A player controlled character. Blockbuster videos to collect. And a place to turn them in. In the path of the nav mesh agent I place a &#8220;blockbuster video&#8221; and at the destination I place a character to represent the turn in. A majority of my time is spent hammering out logic around these game elements.

The blockbuster videos are collectables. It&#8217;s collider acts as a trigger to the player. The collision logic is handled in a scriptable object. Player control is taken away, the player character animates to celebrate (complete with particle effects), the item is added to the player&#8217;s inventory, and the blockbuster video is deactivated. When the game starts, every blockbuster video adds itself to a runtime set Scriptable Object.

The hardest part was rolling my own dialogue system. Before all videos are collected, the blockbuster employee prompts you to collect them &#8220;to avoid late fees.&#8221; Once all videos are collected, I want a different dialogue to play. The blockbuster employee has a collider that is set to trigger the dialogue sequence. I then deactivate a couple canvases that create the illusion of the zooming in on the characters talking to each other. While you can add 3D characters to canvases, you have to scale them greatly to see them. I scale my characters to 300 to achieve the effect.

Its getting late on Sunday. I remember thinking &#8220;I would love to build a combat system for the game&#8221; on Saturday. The player character could be a sorceress flinging fireballs at some oppositional force. This idea is cut because&#8230; It&#8217;s time to add player control. Easy. I create a MonoBehaviour that takes a public nav mesh agent and sets its destination on right click.

Now it is time to build out an environment. I have mucked around with Probuilder so I build something more extensive out. Now that I have a bigger environment, I add more blockbuster collectables in the scene. I&#8217;m happy scaling more collectables doesn&#8217;t require any additional logic.

Time is getting razor thin. My polish is to add a ground texture to an element of the environment, add a skybox, and tweak the UI colors.

That&#8217;s all I have time for! I upload my game to my play.unity.com profile, fill this information in to the game jam forms, and feel satisfied that I was able to get far in a short amount of time. You can check out my game jam game <a rel="noreferrer noopener" href="https://play.unity.com/mg/other/global-game-jam-2021-riko-s-lost-blockbuster-videos" data-type="URL" data-id="https://play.unity.com/mg/other/global-game-jam-2021-riko-s-lost-blockbuster-videos" target="_blank">here</a>.

Afterwards, all the jammers at my site present their projects. I present mine in an ad hoc presentation. I wish I had prepared more for the presentations but sais la vive!

I enjoyed my time participating in global game jam 2021!