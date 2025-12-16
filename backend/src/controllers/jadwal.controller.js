const jadwalService = require('../services/jadwal.service');

class JadwalController {
  async getAllJadwal(req, res, next) {
    try {
      const filters = {
        prodi: req.query.prodi,
        semester: req.query.semester,
        hari: req.query.hari,
        search: req.query.search,
      };
      
      const jadwalList = await jadwalService.getAllJadwal(filters);
      
      res.status(200).json({
        success: true,
        data: jadwalList,
      });
    } catch (error) {
      next(error);
    }
  }
  
  async getJadwalById(req, res, next) {
    try {
      const { id } = req.params;
      const jadwal = await jadwalService.getJadwalById(id);
      
      res.status(200).json({
        success: true,
        data: jadwal,
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = new JadwalController();
