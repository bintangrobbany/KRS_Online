const userService = require('../services/user.service');

class UserController {
  async updateProfile(req, res, next) {
    try {
      const userId = req.user.userId;
      const user = await userService.updateProfile(userId, req.body);
      
      res.status(200).json({
        success: true,
        message: 'Profile berhasil diperbarui',
        data: user,
      });
    } catch (error) {
      next(error);
    }
  }
  
  async getSavedClasses(req, res, next) {
    try {
      const userId = req.user.userId;
      const savedClasses = await userService.getSavedClasses(userId);
      
      res.status(200).json({
        success: true,
        data: savedClasses,
      });
    } catch (error) {
      next(error);
    }
  }
  
  async saveClass(req, res, next) {
    try {
      const userId = req.user.userId;
      const { jadwalId } = req.body;
      
      const savedClass = await userService.saveClass(userId, jadwalId);
      
      res.status(201).json({
        success: true,
        message: 'Kelas berhasil disimpan',
        data: savedClass,
      });
    } catch (error) {
      next(error);
    }
  }
  
  async unsaveClass(req, res, next) {
    try {
      const userId = req.user.userId;
      const { jadwalId } = req.params;
      
      const result = await userService.unsaveClass(userId, jadwalId);
      
      res.status(200).json({
        success: true,
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }
  
  async getNotifications(req, res, next) {
    try {
      const userId = req.user.userId;
      const notifications = await userService.getNotifications(userId);
      
      res.status(200).json({
        success: true,
        data: notifications,
      });
    } catch (error) {
      next(error);
    }
  }
  
  async markNotificationAsRead(req, res, next) {
    try {
      const userId = req.user.userId;
      const { id } = req.params;
      
      const notification = await userService.markNotificationAsRead(userId, id);
      
      res.status(200).json({
        success: true,
        data: notification,
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = new UserController();
