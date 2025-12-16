const express = require('express');
const jadwalController = require('../controllers/jadwal.controller');
const authMiddleware = require('../middlewares/auth.middleware');

const router = express.Router();

// All jadwal routes require authentication
router.use(authMiddleware);

// Get all jadwal with filters
router.get('/', jadwalController.getAllJadwal);

// Get jadwal by ID
router.get('/:id', jadwalController.getJadwalById);

module.exports = router;
