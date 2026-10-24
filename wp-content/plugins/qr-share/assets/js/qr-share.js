(function () {
	'use strict';

	const SVG_NS = 'http://www.w3.org/2000/svg';
	const QUIET_ZONE = 4;

	/**
	 * Build an SVG element for the given text. QR codes need dark modules on a
	 * light background regardless of the page theme, so the colours are fixed.
	 *
	 * @param {string} text Text to encode.
	 * @return {SVGElement} The QR code.
	 */
	function buildSvg(text) {
		const qr = window.qrcode(0, 'M');
		qr.addData(text);
		qr.make();

		const count = qr.getModuleCount();
		const total = count + QUIET_ZONE * 2;
		let path = '';
		for (let row = 0; row < count; row++) {
			for (let col = 0; col < count; col++) {
				if (qr.isDark(row, col)) {
					path += `M${col + QUIET_ZONE} ${row + QUIET_ZONE}h1v1h-1z`;
				}
			}
		}

		const svg = document.createElementNS(SVG_NS, 'svg');
		svg.setAttribute('viewBox', `0 0 ${total} ${total}`);
		svg.setAttribute('shape-rendering', 'crispEdges');
		svg.setAttribute('focusable', 'false');

		const background = document.createElementNS(SVG_NS, 'rect');
		background.setAttribute('width', String(total));
		background.setAttribute('height', String(total));
		background.setAttribute('fill', '#ffffff');
		svg.appendChild(background);

		const modules = document.createElementNS(SVG_NS, 'path');
		modules.setAttribute('d', path);
		modules.setAttribute('fill', '#000000');
		svg.appendChild(modules);

		return svg;
	}

	/**
	 * Fill a panel's code area once.
	 *
	 * @param {HTMLElement} panel A [data-qr-share] element.
	 */
	function renderCode(panel) {
		const holder = panel.querySelector('.qr-share__code');
		const url = panel.dataset.url;
		if (!holder || !url || holder.firstChild) {
			return;
		}
		holder.setAttribute('role', 'img');
		holder.setAttribute('aria-label', panel.dataset.codeLabel || '');
		holder.appendChild(buildSvg(url));
	}

	/**
	 * Wire the copy and native-share buttons of a panel.
	 *
	 * @param {HTMLElement} panel A [data-qr-share] element.
	 */
	function bindActions(panel) {
		const url = panel.dataset.url || '';
		const field = panel.querySelector('.qr-share__field');
		const copy = panel.querySelector('.qr-share__copy');
		const nativeShare = panel.querySelector('.qr-share__native');
		const status = panel.querySelector('.qr-share__status');

		const say = (message) => {
			if (status) {
				status.textContent = message;
			}
		};

		if (field) {
			field.addEventListener('focus', () => field.select());
		}

		if (copy) {
			copy.hidden = false;
			copy.addEventListener('click', async () => {
				try {
					await navigator.clipboard.writeText(url);
					say(panel.dataset.copied || '');
				} catch {
					if (field) {
						field.focus();
						field.select();
					}
					say(panel.dataset.copyFailed || '');
				}
			});
		}

		if (nativeShare && typeof navigator.share === 'function') {
			nativeShare.hidden = false;
			nativeShare.addEventListener('click', async () => {
				try {
					await navigator.share({ title: document.title, url });
				} catch {
					// The visitor dismissed the share sheet; nothing to do.
				}
			});
		}
	}

	/**
	 * Wire a floating button and its dialog.
	 *
	 * @param {HTMLElement} root A [data-qr-share-floating] element.
	 */
	function bindFloating(root) {
		const open = root.querySelector('.qr-share-floating__open');
		const dialog = root.querySelector('dialog');
		const close = root.querySelector('.qr-share-dialog__close');
		const panel = root.querySelector('[data-qr-share]');
		if (!open || !dialog || !panel || typeof dialog.showModal !== 'function') {
			return;
		}

		open.hidden = false;
		open.addEventListener('click', () => {
			renderCode(panel);
			dialog.showModal();
		});
		if (close) {
			close.addEventListener('click', () => dialog.close());
		}
		// The dialog element itself is only the backdrop area; the body fills the rest.
		dialog.addEventListener('click', (event) => {
			if (event.target === dialog) {
				dialog.close();
			}
		});
	}

	function init() {
		document.querySelectorAll('[data-qr-share]').forEach((panel) => {
			bindActions(panel);
			if (!panel.closest('[data-qr-share-floating]')) {
				renderCode(panel);
			}
		});
		document.querySelectorAll('[data-qr-share-floating]').forEach(bindFloating);
	}

	if ('loading' === document.readyState) {
		document.addEventListener('DOMContentLoaded', init);
	} else {
		init();
	}
})();
