---
title: "Routine Mark: track your habits"
slug: routine-mark
excerpt: "A tiny offline-first habit tracker: one big button to mark today done, plus a calendar of your streaks."
wp_post_id: 3709
url: https://routinemark.com
repo: aallbrig/routine-mark
image: images/routine-mark.png
---

Live site: [routinemark.com](https://routinemark.com)
Routine Mark answers "did you do the thing today?" with one large button.
Create a calendar for each habit, such as the gym, a weekly class or a home-cooked meal, and watch the green dots build up. There is no account and no backend: it works offline after the first load and keeps your data in the browser. It also ships with a user manual.

![Routine Mark home page](routine-mark.png)

### Tech stack

- **Generator:** [Eleventy (11ty)](https://www.11ty.dev/) with Nunjucks templates
- **UI:** Bootstrap 5 from a CDN, custom CSS animations (the rainbow completion border), vanilla ES6 JavaScript
- **Persistence:** `localStorage`, with a service worker for offline caching
- **Deployment:** GitHub Pages through GitHub Actions
- **License:** MIT

Source: [aallbrig/routine-mark](https://github.com/aallbrig/routine-mark)
