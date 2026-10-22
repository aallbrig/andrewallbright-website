---
title: "Sandworm of Dune"
slug: sandworm-of-arrakis
excerpt: "A micro game where you steer a sandworm across the desert and feed on spice, sketched after watching Dune (2021)."
wp_post_id: 3731
url: https://sandwormofdune.com/
repo: aallbrig/dune-sandworm-micro-prototype
image: images/sandworm-of-arrakis.png
---

Live site: [sandwormofdune.com](https://sandwormofdune.com/)

I watched Dune (2021), was wildly impressed, and decided to sketch a virtual toy.
You play as a sandworm that rises out of the dunes and must feed on spice. Move with tap, click, joystick or WASD, so it plays the same on a phone, a gamepad or a keyboard.
It is a micro prototype from October 2021, built quickly to explore how a player-controlled worm can feel.

![Sandworm of Dune gameplay](sandworm-of-arrakis.png)

### Tech stack

- **Engine:** Unity 2020.3 (LTS) with the Universal Render Pipeline, exported as WebGL
- **Language:** C# (almost all of the repo)
- **Unity packages:** Animation Rigging to drive the segmented worm body, Cinemachine for the camera, the Input System for unified touch, mouse, gamepad and keyboard controls, Device Simulator for mobile testing
- **Delivery:** GitHub Actions builds the WebGL player and deploys it to sandwormofdune.com
- **Extras:** a QR code in the README so the game can be opened from a phone

Source: [aallbrig/dune-sandworm-micro-prototype](https://github.com/aallbrig/dune-sandworm-micro-prototype)
