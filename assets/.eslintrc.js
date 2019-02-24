module.exports = {
	env: {
		browser: true,
		es6: true
	},
	extends: ['airbnb-base', 'plugin:vue/recommended', '@vue/prettier'],
	globals: {
		Atomics: 'readonly',
		SharedArrayBuffer: 'readonly'
	},
	parserOptions: {
		parser: 'babel-eslint',
		ecmaVersion: 2018,
		sourceType: 'module'
	},
	plugins: ['vue'],
	rules: {
		"no-console": 0
	}
};
