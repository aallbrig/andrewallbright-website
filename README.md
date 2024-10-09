# Andrew Allbright website

Switch website from Wordpress HA on AWS to just being a hugo website hosted on GitHub pages.

### [AndrewAllbright.com](https://andrewallbright.com)

## Development
```bash
# develop
hugo server
# build assets
HUGO_ENV="production" hugo -t github-style
```

### Tech Stack
1. [x] Hugo
1. [x] GitHub Pages
1. [x] AWS Route53
