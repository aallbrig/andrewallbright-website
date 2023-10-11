const puppeteer = require('puppeteer');
const { expect } = require('chai');

const website_host = process.env.WEBSITE_HOST; // protocol + hostname + port

describe('Personal Website Behavior', function() {
    describe('Home Page', function() {
        let page;
        let browser;

        before(async function() {
            browser = await puppeteer.launch();
            page = await browser.newPage();
        });

        after(async function() {
            await browser.close();
        });

        it('Should load', async function() {
            const response = await page.goto(website_host);
            expect(response.status()).to.equal(200);
        });
    });
});
