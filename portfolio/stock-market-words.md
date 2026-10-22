---
title: "Stock Market Words"
slug: stock-market-words
excerpt: "Paste any text and find every hidden stock ticker, scored across six investment-strategy lenses. Runs in your browser."
wp_post_id: 3895
url: https://stockmarketwords.com
repo: aallbrig/stock-market-words
image: images/stock-market-words.png
---
Stock Market Words started from a whimsical question: what if the words in a dictionary were stock tickers?
Paste a news article, earnings transcript or Reddit post and it scans for valid ticker symbols, then scores each across six investment-strategy lenses.
The ticker extraction runs entirely in your browser. The site also publishes articles and tracks more than 3,000 tickers daily.

![Stock Market Words home page](stock-market-words.png)

### Tech stack

- **Site:** Hugo static site with Bootstrap and DataTables, vanilla JavaScript (about 32% of the repo), multilingual
- **Ticker engine:** a client-side JavaScript `TickerEngine` with its own performance-profiling tests
- **Data pipeline:** Python (about 38% of the repo) with SQL migrations, producing daily ticker data and strategy scores, run on a systemd schedule
- **Testing:** Jest unit and performance tests, Playwright end-to-end tests with HTML reports
- **Quality:** ESLint, Stylelint, git hooks, pre-commit, Taskfile, GitHub Actions

Source: [aallbrig/stock-market-words](https://github.com/aallbrig/stock-market-words)
