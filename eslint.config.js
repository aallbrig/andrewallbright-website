import js from '@eslint/js';
import globals from 'globals';

export default [
	{
		ignores: [
			'node_modules/',
			'vendor/',
			'dist/',
			'build/',
			'coverage/',
			'**/assets/vendor/**',
		],
	},
	js.configs.recommended,
	{
		languageOptions: {
			ecmaVersion: 2022,
			sourceType: 'script',
			globals: { ...globals.browser },
		},
		linterOptions: { reportUnusedDisableDirectives: 'error' },
		rules: {
			eqeqeq: ['error', 'always'],
			curly: ['error', 'all'],
			'no-var': 'error',
			'prefer-const': 'error',
			'no-implicit-globals': 'error',
			'no-eval': 'error',
			'no-implied-eval': 'error',
			'no-new-func': 'error',
			'no-script-url': 'error',
			'no-param-reassign': 'error',
			'no-shadow': 'error',
			'no-unused-vars': 'error',
			'no-undef': 'error',
			'no-console': 'error',
			'no-alert': 'error',
			'no-throw-literal': 'error',
			'no-return-await': 'error',
			'require-await': 'error',
			'no-unsafe-optional-chaining': 'error',
			'no-restricted-properties': [
				'error',
				{ property: 'innerHTML', message: 'Build DOM nodes instead of parsing strings.' },
				{ property: 'outerHTML', message: 'Build DOM nodes instead of parsing strings.' },
				{
					property: 'insertAdjacentHTML',
					message: 'Build DOM nodes instead of parsing strings.',
				},
			],
		},
	},
	{
		files: ['**/blocks/*/editor.js'],
		languageOptions: { globals: { wp: 'readonly' } },
	},
	{
		files: ['**/tests/js/**/*.js', 'eslint.config.js'],
		languageOptions: { sourceType: 'module', globals: { ...globals.node } },
	},
];
