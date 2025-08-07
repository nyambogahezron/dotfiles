import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

/** @type {import('next').NextConfig} */
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
