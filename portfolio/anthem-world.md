---
title: "Anthem World"
slug: anthem-world
excerpt: "An interactive world map for exploring and ranking the national anthems of all 193 UN-recognized countries."
wp_post_id: 3893
url: https://anthemworld.net
repo: aallbrig/anthemworld
image: images/anthem-world.png
---

Live site: [anthemworld.net](https://anthemworld.net)
Anthem World lets you click a country on a map and hear its national anthem, see who composed it, when it was adopted and what it means.
A sortable, searchable table answers questions like which country has the youngest anthem. In Anthem Battle, visitors hear two anthems and vote; votes feed an ELO rating, the same method used for chess, to build a community leaderboard. Votes count for more the longer you listen.

![Anthem World home page](anthem-world.png)

### Tech stack

- **Frontend:** Hugo static site, Bootstrap 5, Leaflet.js with GeoJSON for the map, vanilla JavaScript (about 60% of the repo)
- **Data CLI:** Go with SQLite, which discovers, health-checks and formats data from open sources: REST Countries, Wikidata SPARQL and Wikimedia Commons audio
- **Backend for voting:** AWS SAM stacks for the game and leaderboard APIs, plus a WAF and GitHub OIDC deploy role
- **Testing:** Go tests for the CLI and Playwright end-to-end tests for the site
- **Dev workflow:** Taskfile, pre-commit hooks, tmuxinator session, docker-compose, observability setup

Source: [aallbrig/anthemworld](https://github.com/aallbrig/anthemworld)
