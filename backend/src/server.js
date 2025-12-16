require('dotenv').config();
const express = require('express');
const cors = require('cors');
const routes = require('./routes');
const errorHandler = require('./middlewares/error.middleware');
const config = require('./config/config');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Routes
app.use('/api', routes);

// Error handling
app.use(errorHandler);

// Start server
const PORT = config.port;

app.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════════╗
║   KRS Online Backend Server Running    ║
║   Port: ${PORT}                           ║
║   Environment: ${config.nodeEnv}      ║
╚════════════════════════════════════════╝
  `);
});

module.exports = app;
