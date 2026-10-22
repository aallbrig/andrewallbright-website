---
title: "What Do My Taxes Pay For?"
slug: what-do-my-taxes-pay-for
excerpt: "Enter your income and see how your federal taxes break down across government spending categories."
wp_post_id: 3897
url: https://whatdomytaxespayfor.com
repo: aallbrig/what-do-my-taxes-pay-for
image: images/what-do-my-taxes-pay-for.png
---

Live site: [whatdomytaxespayfor.com](https://whatdomytaxespayfor.com)
This site applies progressive US tax brackets to your income, then splits what you owe into the budget categories the federal government reports, such as defense, health and interest on the debt.
Pick any budget year from 1962 to 2025 to compare how spending priorities changed, and optionally add a state for state income tax.

The budget data comes from [USAspending.gov](https://www.usaspending.gov/#/explorer/budget_function), and a companion Python CLI downloads and manages it.

![What Do My Taxes Pay For? calculator](what-do-my-taxes-pay-for.png)

### Tech stack

- **Frontend:** Bootstrap 5 and vanilla JavaScript
- **Backend:** PHP with MySQL for application data, SQLite for budget data
- **Data CLI:** Python 3.12 (`taxpayfor`) for downloading and loading federal budget and census data
- **Hosting:** DreamHost shared hosting, deployed over SSH with rsync, with Apache config in the repo
- **Quality:** pre-commit hooks, Taskfile, phased implementation notes in `docs/`

Source: [aallbrig/what-do-my-taxes-pay-for](https://github.com/aallbrig/what-do-my-taxes-pay-for)
