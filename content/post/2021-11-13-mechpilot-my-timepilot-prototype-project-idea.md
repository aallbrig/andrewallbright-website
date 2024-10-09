---
title: 'MechPilot: my TimePilot prototype project idea'
author: Andrew Allbright
type: post
date: 2021-11-13T19:22:58+00:00
url: /mechpilot-my-timepilot-prototype-project-idea/
categories:
  - Game Programming

---
## The Inspiration {.wp-block-heading}

I&#8217;m going to go to my local video game arcade bar to work on more Unity programming (aka &#8220;game&#8221; programming, although I feel silly saying that). At that bar is an arcade cabinet called Time Pilot. I had skipped over that cabinet quite a few times before I finally started playing it. The game is fun! It is relatively complex yet relatively simple. A gem from the 1980s!<figure class="wp-block-embed is-type-video is-provider-youtube wp-block-embed-youtube wp-embed-aspect-4-3 wp-has-aspect-ratio">

<div class="wp-block-embed__wrapper">
</div></figure> 

My plan is to create a new Unity project that is inspired by this game. I also love mech (aka giant robots) anime. I think it would be really neat to see the player control a mech. I think using procedural animation might help me create something that looks cool, using basic Unity shapes.<figure class="wp-block-embed is-type-video is-provider-youtube wp-block-embed-youtube wp-embed-aspect-16-9 wp-has-aspect-ratio">

<div class="wp-block-embed__wrapper">
</div></figure> 

## The plan {.wp-block-heading}

Like my other recent Unity micro projects, I will target WebGL and create something that I can play from my phone. I&#8217;ll use GitHub Actions as my continuous integration/continuous delivery (CI/CD) solution. I&#8217;ll deploy to GitHub Pages so I can view my project from my phone. When I am ready for play testers I will generate a QR code so the tester can play the game on their own phone.

As for the game, I will use swipe to move the player. It will be 2.5D. All other non player objects move the opposite direction in the same speed as the player&#8217;s avatar (a mech). Parallax can later be achieved by varying the speed.

I think focusing on movement as the core mechanic would be good. The mech automatically engage targets that are within a 90 degree arc in front. The mech&#8217;s front turns to face the direction of the swipe, thereby moving the 90 degree arc. Tap to dash.

The mech starts with a simple laser cannon. Perhaps there ought to be upgrades like shoulder mounted missiles or other types of rifles.

The fantasy the game needs to provide is feeling like you are an elite pilot engaging in high intensity combat. The focus on maneuvering and the fact that the mech automatically engages targets should help achieve that. I partly want to allow the player to tap to choose targets, but I wonder if just focusing on maneuvering is game enough.

I would love to write AI for my enemies. However; for the beginning stages I think I will implement simple chase behavior.

High level TODO list (after regular project setup):

<ol class="wp-block-list">
  <li>
    The player is able to control a player avatar. The player&#8217;s avatar rotates towards the direction of a swipe. The player&#8217;s avatar dashes when a tap is detected.
  </li>
  <li>
    The player sees a still dummy object in the center of the screen. That object moves opposite of the direction the player&#8217;s avatar is moving. If the object moves outside the bounds of the screen, move it back to a reset point on the screen (behind player&#8217;s avatar?). If the player&#8217;s avatar collides with the object, the player&#8217;s avatar is destroyed.
  </li>
  <li>
    The player is able to see a 90 degree arc (aka &#8216;field of view&#8217; or more accurately &#8216;field of engagement view&#8217; (FOEV)) in front of their avatar. That FOEV keeps in front of the player&#8217;s avatar. When the dummy object is inside that FOEV, a projectile is fired towards the object. When the projectile collides with the dummy object, it is destroyed and the player gains points. Player points are displayed at the top.
  </li>
  <li>
    A basic type enemy is spawned in at a set interval. It will chase the player&#8217;s avatar. If destroyed, the player will be awarded points. The enemy will fire projectiles at the player. If the player is hit, they are destroyed. Reload the page to play again.
  </li>
  <li>
    A squadron of of basic enemy types is spawned in at a set interval. If all members of a squadron are destroyed, the player is awarded bonus points.
  </li>
  <li>
    A &#8220;mothership&#8221; enemy type is spawned in after a number of enemies are destroyed. Once destroyed, the level is complete. A next level will load in. Reload the same level but keep the player score.
  </li>
  <li>
    A player interacts with a start menu on game load. The player is able to start the game. The player is also able to see a leaderboard. For every round of play, the time the player stayed alive is recorded along with the score, number of enemies destroyed, and number of stages cycled through. Upon game over, the player is able to enter initials (3? 4? 5? 6?). Swipe up or down to cycle characters. Tap to enter the initial. Ideally, the leaderboard persists even if the player reloads the web page.
  </li>
</ol>

Anyways, time to bike over to the arcade bar and see how much of this vision I can execute. At any rate, I&#8217;ll have a cool blog post to reference in my github project&#8217;s README.md file!

Wish me luck.