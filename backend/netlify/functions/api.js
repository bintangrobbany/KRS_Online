const serverless = require('serverless-http');
const app = require('../../src/app');

// Wrap Express app dengan serverless-http
exports.handler = serverless(app);
