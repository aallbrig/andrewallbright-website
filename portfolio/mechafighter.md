---
title: "MechaFighter"
slug: mechafighter
excerpt: "An alpha browser game that mixes Time Pilot, Daigaiku and UN Squadron, built in Unity with behavior trees and shipped as WebGL."
wp_post_id: 3914
url: https://mechafighter.com/
repo: aallbrig/mecha-pilot
image: images/mechafighter.png
---

Live site: [mechafighter.com](https://mechafighter.com/)

Mecha Fighter is an alpha-stage browser game inspired by Time Pilot, Daigaiku and UN Squadron.
It has a title screen with Play, Scores and How To Play, and runs on desktop and phones straight from the browser, with no install.
It grew out of an earlier micro prototype, [Mech Pilot](https://github.com/aallbrig/mech-pilot), where I practised AI programming for game enemies.

![Mecha Fighter title screen](mechafighter.png)

### Tech stack

- **Engine:** Unity 2021.3 (LTS) with the Universal Render Pipeline, exported as WebGL
- **Language:** C# (about 47% of the repo) plus HLSL and ShaderLab for custom shaders
- **Gameplay AI:** [Fluid Behavior Tree](https://github.com/ashblue/fluid-behavior-tree) and Fluid State Machine packages
- **Unity packages:** Cinemachine for cameras, the Input System for keyboard, gamepad and touch, Addressables for content loading, 2D Tilemap and ProBuilder for level building
- **Delivery:** GitHub Actions builds the game and publishes a QA build to GitHub Pages, with production served from mechafighter.com
- **Tooling:** Docker setup for repeatable builds

Source: [aallbrig/mecha-pilot](https://github.com/aallbrig/mecha-pilot)
