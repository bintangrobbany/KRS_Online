const express = require('express');
const { body } = require('express-validator');
const userController = require('../controllers/user.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const validate = require('../middlewares/validator.middleware');

const router = express.Router();

// All user routes require authentication
router.use(authMiddleware);

// Update Profile
router.put('/profile', userController.updateProfile);

// Saved Classes
router.get('/saved-classes', userController.getSavedClasses);
router.post(
  '/saved-classes',
  [
    body('jadwalId').notEmpty().withMessage('Jadwal ID harus diisi'),
  ],
  validate,
  userController.saveClass
);
router.delete('/saved-classes/:jadwalId', userController.unsaveClass);

// Notifications
router.get('/notifications', userController.getNotifications);
router.patch('/notifications/:id/read', userController.markNotificationAsRead);

module.exports = router;
