/** @type {import('next').NextConfig} */
const path = require('path');

const nextConfig = {
	images: {
		domains: ['image.tmdb.org', 'i0.wp.com'],
	},
	webpack: (config) => {
		config.resolve = config.resolve || {};
		config.resolve.alias = config.resolve.alias || {};
		config.resolve.alias['@repo/services'] = path.resolve(
			__dirname,
			'../../packages/services/src'
		);
		return config;
	},
};

export default nextConfig;
