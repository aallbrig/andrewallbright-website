const puppeteer = require('puppeteer');
const { expect } = require('chai');

// root of website in scheme + domain name + port format e.g. https://example.com
const website_url = new URL(process.env.WEBSITE_URL);
const blog_archive_url = new URL('/blog/', website_url);
const contact_url = new URL('/contact/', website_url);

const puppeteer_setting_headless = process.env.PUPPETEER_SETTING_HEADLESS !== 'false';
const puppeteer_options = {
    headless: puppeteer_setting_headless,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
};

describe('Personal Website Behavior', function() {
    let browser;
    let page;

    before(async function() {
        browser = await puppeteer.launch(puppeteer_options);
    });
    beforeEach(async function() {
        page = await browser.newPage();
    });
    afterEach(async function() {
        await page.close();
    });
    after(async function() {
        await browser.close();
    });

    describe('Home Page', function() {
        it('Should load', async function() {
            const response = await page.goto(website_url);
            expect(response.status()).to.equal(200);
        });
    });
    describe('Blog Archive', function() {
        it('Should load', async function() {
            const response = await page.goto(blog_archive_url);
            expect(response.status()).to.equal(200);
        });
    });
    describe('Contact Form', function() {
        it('Should load', async function() {
            const response = await page.goto(contact_url);
            expect(response.status()).to.equal(200);
        });
    });
});
