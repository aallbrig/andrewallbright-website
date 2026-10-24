import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { JSDOM } from 'jsdom';

const root = new URL('../../', import.meta.url);
const read = (path) => readFileSync(new URL(path, root), 'utf8');

const MARKUP = `
<div class="qr-share-floating" data-qr-share-floating>
	<button type="button" class="qr-share-floating__open" hidden>Open</button>
	<dialog class="qr-share-dialog">
		<div class="qr-share-dialog__body">
			<div class="qr-share" data-qr-share data-url="https://example.test/page/"
				data-copied="Link copied" data-copy-failed="Press Ctrl+C" data-code-label="QR code">
				<div class="qr-share__code"></div>
				<input class="qr-share__field" type="text" readonly value="https://example.test/page/" />
				<button type="button" class="qr-share__copy" hidden>Copy</button>
				<button type="button" class="qr-share__native" hidden>Share</button>
				<p class="qr-share__status"></p>
			</div>
			<button type="button" class="qr-share-dialog__close">Close</button>
		</div>
	</dialog>
</div>
<div class="qr-share" id="inline" data-qr-share data-url="https://example.test/inline/"
	data-copied="Link copied" data-copy-failed="Press Ctrl+C" data-code-label="QR code">
	<div class="qr-share__code"></div>
	<input class="qr-share__field" type="text" readonly value="https://example.test/inline/" />
	<button type="button" class="qr-share__copy" hidden>Copy</button>
	<button type="button" class="qr-share__native" hidden>Share</button>
	<p class="qr-share__status"></p>
</div>`;

async function load({ clipboard, share } = {}) {
	const dom = new JSDOM(`<!doctype html><body>${MARKUP}</body>`, { runScripts: 'outside-only' });
	const { window } = dom;
	const dialog = window.document.querySelector('dialog');
	dialog.showModal = () => dialog.setAttribute('open', '');
	dialog.close = () => dialog.removeAttribute('open');
	Object.defineProperty(window.navigator, 'clipboard', { value: clipboard, configurable: true });
	Object.defineProperty(window.navigator, 'share', { value: share, configurable: true });
	window.eval(read('assets/vendor/qrcode-generator/qrcode.js'));
	window.eval('window.qrcode = qrcode;');
	window.eval(read('assets/js/qr-share.js'));
	await new Promise((resolve) => {
		if (window.document.readyState === 'loading') {
			window.document.addEventListener('DOMContentLoaded', resolve);
		} else {
			resolve();
		}
	});
	return window;
}

const tick = (window) => new Promise((resolve) => window.setTimeout(resolve, 0));

test('inline panel renders a QR svg at load; floating panel waits for open', async () => {
	const window = await load();
	const doc = window.document;
	assert.ok(doc.querySelector('#inline .qr-share__code svg path'));
	assert.equal(doc.querySelector('dialog .qr-share__code').children.length, 0);

	const open = doc.querySelector('.qr-share-floating__open');
	assert.equal(open.hidden, false);
	open.click();
	assert.ok(doc.querySelector('dialog').hasAttribute('open'));
	assert.ok(doc.querySelector('dialog .qr-share__code svg path'));
});

test('close button and backdrop click close the dialog', async () => {
	const window = await load();
	const doc = window.document;
	const dialog = doc.querySelector('dialog');
	doc.querySelector('.qr-share-floating__open').click();
	doc.querySelector('.qr-share-dialog__close').click();
	assert.equal(dialog.hasAttribute('open'), false);

	doc.querySelector('.qr-share-floating__open').click();
	dialog.click();
	assert.equal(dialog.hasAttribute('open'), false);
});

test('copy writes the url and reports success', async () => {
	let written = '';
	const window = await load({
		clipboard: {
			writeText: (text) => {
				written = text;
				return Promise.resolve();
			},
		},
	});
	const panel = window.document.querySelector('#inline');
	panel.querySelector('.qr-share__copy').click();
	await tick(window);
	assert.equal(written, 'https://example.test/inline/');
	assert.equal(panel.querySelector('.qr-share__status').textContent, 'Link copied');
});

test('copy falls back to a manual hint when the clipboard is unavailable', async () => {
	const window = await load();
	const panel = window.document.querySelector('#inline');
	panel.querySelector('.qr-share__copy').click();
	await tick(window);
	assert.equal(panel.querySelector('.qr-share__status').textContent, 'Press Ctrl+C');
});

test('native share button only shows when navigator.share exists', async () => {
	const without = await load();
	assert.equal(without.document.querySelector('#inline .qr-share__native').hidden, true);

	let shared = null;
	const window = await load({
		share: (data) => {
			shared = data;
			return Promise.resolve();
		},
	});
	const button = window.document.querySelector('#inline .qr-share__native');
	assert.equal(button.hidden, false);
	button.click();
	await tick(window);
	assert.equal(shared.url, 'https://example.test/inline/');
});

test('a dismissed share sheet does not throw', async () => {
	const window = await load({ share: () => Promise.reject(new Error('AbortError')) });
	window.document.querySelector('#inline .qr-share__native').click();
	await tick(window);
});
