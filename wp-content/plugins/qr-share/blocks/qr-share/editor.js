(function (wp) {
	'use strict';

	const { registerBlockType } = wp.blocks;
	const { InspectorControls, useBlockProps } = wp.blockEditor;
	const { PanelBody, RangeControl } = wp.components;
	const { createElement, Fragment } = wp.element;
	const { __ } = wp.i18n;
	const ServerSideRender = wp.serverSideRender;

	registerBlockType('qr-share/qr-share', {
		edit: function ({ attributes, setAttributes }) {
			return createElement(
				Fragment,
				null,
				createElement(
					InspectorControls,
					null,
					createElement(
						PanelBody,
						{ title: __('QR code', 'qr-share') },
						createElement(RangeControl, {
							label: __('Size (px)', 'qr-share'),
							min: 128,
							max: 512,
							step: 16,
							value: attributes.size,
							onChange: (size) => setAttributes({ size }),
						}),
					),
				),
				createElement(
					'div',
					useBlockProps(),
					createElement(ServerSideRender, {
						block: 'qr-share/qr-share',
						attributes,
					}),
				),
			);
		},
		save: function () {
			return null;
		},
	});
})(window.wp);
