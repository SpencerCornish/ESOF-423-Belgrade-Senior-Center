import faker from "faker";
import puppeteer from "puppeteer";
import "@babel/polyfill";
let page;
let browser;
const width = 1024;
const height = 768;

const APP = 'http://localhost:5000/';


beforeAll(async () => {
    browser = await puppeteer.launch({
        // headless: false,
        // slowMo: 120,
        // args: [`--window-size=${width},${height}`]
    });
    page = await browser.newPage();
    await page.setViewport({ width, height });
});
afterAll(() => {
    browser.close();
});

describe("Login form", () => {
    test("renders correct components", async () => {
        await page.goto(APP);
        await page.waitForSelector("#home-container");
        await page.waitForSelector("#email-input");
        await page.waitForSelector("#pass-input");
        await page.waitForSelector("#reset-pass-button");
        await page.waitForSelector("#cancel-button");
        await page.waitForSelector("#login-submit-button");

    }, 16000);
    test("error when invalid email", async () => {
        await page.goto(APP);
        await page.waitForSelector("#home-container");
        await page.click("#email-input");
        await page.type("#email-input", faker.random.alphaNumeric(10));
        await page.click("#pass-input");
        await page.type("#pass-input", faker.random.alphaNumeric(5));
        await page.click("#login-submit-button");

        await page.waitForSelector("#hint-invalidemail");
    }, 16000);
    test("error when email does not exist", async () => {
        await page.goto(APP);
        await page.waitForSelector("#home-container");
        await page.click("#email-input");
        await page.type("#email-input", faker.internet.exampleEmail('spencer','cornish'));
        await page.click("#pass-input");
        await page.type("#pass-input", faker.random.alphaNumeric(8));
        await page.click("#login-submit-button");

        await page.waitForSelector("#hint-emailnotfound");
    }, 16000);
    test("error when incorrect password", async () => {
        await page.goto(APP);
        await page.waitForSelector("#home-container");
        await page.click("#email-input");
        await page.type("#email-input", 'spenca2015@gmail.com');
        await page.click("#pass-input");
        await page.type("#pass-input", faker.random.alphaNumeric(9));
        await page.click("#login-submit-button");

        await page.waitForSelector("#hint-invalidpassword");
    }, 16000);
});