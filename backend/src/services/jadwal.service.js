const { db } = require('../config/firebase');

class JadwalService {
  constructor() {
    this.jadwalCollection = db.collection('jadwal');
    this.mataKuliahCollection = db.collection('mata_kuliah');
  }

  async getAllJadwal(filters = {}) {
    const { prodi, semester, hari, search } = filters;
    
    let query = this.jadwalCollection.where('isActive', '==', true);
    
    if (hari) {
      query = query.where('hari', '==', hari);
    }
    
    const snapshot = await query.get();
    
    const jadwalList = [];
    for (const doc of snapshot.docs) {
      const jadwalData = { id: doc.id, ...doc.data() };
      
      // Get mata kuliah details
      const mkDoc = await this.mataKuliahCollection.doc(jadwalData.mataKuliahId).get();
      if (mkDoc.exists) {
        const mkData = { id: mkDoc.id, ...mkDoc.data() };
        
        // Apply mata kuliah filters
        if (prodi && mkData.prodi !== prodi) continue;
        if (semester && mkData.semester !== parseInt(semester)) continue;
        if (search) {
          const searchLower = search.toLowerCase();
          const matchName = mkData.namaMk.toLowerCase().includes(searchLower);
          const matchCode = mkData.kodeMk.toLowerCase().includes(searchLower);
          const matchDosen = jadwalData.dosen.toLowerCase().includes(searchLower);
          if (!matchName && !matchCode && !matchDosen) continue;
        }
        
        jadwalData.mataKuliah = mkData;
        jadwalList.push(jadwalData);
      }
    }
    
    // Sort by day and time
    const dayOrder = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    jadwalList.sort((a, b) => {
      const dayDiff = dayOrder.indexOf(a.hari) - dayOrder.indexOf(b.hari);
      if (dayDiff !== 0) return dayDiff;
      return a.jamMulai.localeCompare(b.jamMulai);
    });
    
    return jadwalList;
  }
  
  async getJadwalById(id) {
    const jadwalDoc = await this.jadwalCollection.doc(id).get();
    
    if (!jadwalDoc.exists) {
      throw new Error('Jadwal tidak ditemukan');
    }
    
    const jadwal = { id: jadwalDoc.id, ...jadwalDoc.data() };
    
    // Get mata kuliah details
    const mkDoc = await this.mataKuliahCollection.doc(jadwal.mataKuliahId).get();
    if (mkDoc.exists) {
      jadwal.mataKuliah = { id: mkDoc.id, ...mkDoc.data() };
    }
    
    return jadwal;
  }
}

module.exports = new JadwalService();
