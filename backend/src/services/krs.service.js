const { db } = require('../config/firebase');

class KRSService {
  constructor() {
    this.krsCollection = db.collection('krs');
    this.jadwalCollection = db.collection('jadwal');
    this.mataKuliahCollection = db.collection('mata_kuliah');
    this.usersCollection = db.collection('users');
  }

  async getKRSByUser(userId, semester, tahunAjaran) {
    let query = this.krsCollection.where('userId', '==', userId);
    
    if (semester) query = query.where('semester', '==', semester);
    if (tahunAjaran) query = query.where('tahunAjaran', '==', tahunAjaran);
    
    const snapshot = await query.orderBy('createdAt', 'desc').get();
    
    const krsList = [];
    for (const doc of snapshot.docs) {
      const krsData = { id: doc.id, ...doc.data() };
      
      // Get jadwal details
      const jadwalDoc = await this.jadwalCollection.doc(krsData.jadwalId).get();
      if (jadwalDoc.exists) {
        const jadwalData = { id: jadwalDoc.id, ...jadwalDoc.data() };
        
        // Get mata kuliah details
        const mkDoc = await this.mataKuliahCollection.doc(jadwalData.mataKuliahId).get();
        if (mkDoc.exists) {
          jadwalData.mataKuliah = { id: mkDoc.id, ...mkDoc.data() };
        }
        
        krsData.jadwal = jadwalData;
      }
      
      krsList.push(krsData);
    }
    
    return krsList;
  }
  
  async addKRS(userId, jadwalId, semester, tahunAjaran) {
    // Check if jadwal exists
    const jadwalDoc = await this.jadwalCollection.doc(jadwalId).get();
    
    if (!jadwalDoc.exists) {
      throw new Error('Jadwal tidak ditemukan');
    }
    
    const jadwal = { id: jadwalDoc.id, ...jadwalDoc.data() };
    
    if (!jadwal.isActive) {
      throw new Error('Kelas ini tidak aktif');
    }
    
    if (jadwal.terisi >= jadwal.kuota) {
      throw new Error('Kuota kelas sudah penuh');
    }
    
    // Get mata kuliah
    const mkDoc = await this.mataKuliahCollection.doc(jadwal.mataKuliahId).get();
    if (!mkDoc.exists) {
      throw new Error('Mata kuliah tidak ditemukan');
    }
    const mataKuliah = { id: mkDoc.id, ...mkDoc.data() };
    
    // Check if already enrolled
    const existingSnapshot = await this.krsCollection
      .where('userId', '==', userId)
      .where('jadwalId', '==', jadwalId)
      .where('semester', '==', semester)
      .where('tahunAjaran', '==', tahunAjaran)
      .get();
    
    if (!existingSnapshot.empty) {
      throw new Error('Anda sudah mengambil mata kuliah ini');
    }
    
    // Check user's total SKS
    const userKRSSnapshot = await this.krsCollection
      .where('userId', '==', userId)
      .where('semester', '==', semester)
      .where('tahunAjaran', '==', tahunAjaran)
      .where('status', 'in', ['pending', 'approved'])
      .get();
    
    let currentSKS = 0;
    for (const doc of userKRSSnapshot.docs) {
      const krs = doc.data();
      const jDoc = await this.jadwalCollection.doc(krs.jadwalId).get();
      if (jDoc.exists) {
        const j = jDoc.data();
        const mDoc = await this.mataKuliahCollection.doc(j.mataKuliahId).get();
        if (mDoc.exists) {
          currentSKS += mDoc.data().sks;
        }
      }
    }
    
    const userDoc = await this.usersCollection.doc(userId).get();
    const user = userDoc.data();
    
    if (currentSKS + mataKuliah.sks > user.maxSks) {
      throw new Error(`Total SKS melebihi batas maksimal (${user.maxSks} SKS)`);
    }
    
    // Create KRS
    const krsRef = this.krsCollection.doc();
    const krsData = {
      id: krsRef.id,
      userId,
      jadwalId,
      semester,
      tahunAjaran,
      status: 'pending',
      createdAt: new Date(),
      updatedAt: new Date(),
    };
    
    await krsRef.set(krsData);
    
    // Update terisi
    await jadwalDoc.ref.update({
      terisi: jadwal.terisi + 1,
      updatedAt: new Date(),
    });
    
    // Get complete data for response
    jadwal.mataKuliah = mataKuliah;
    krsData.jadwal = jadwal;
    
    return krsData;
  }
  
  async deleteKRS(krsId, userId) {
    const krsDoc = await this.krsCollection.doc(krsId).get();
    
    if (!krsDoc.exists) {
      throw new Error('KRS tidak ditemukan');
    }
    
    const krs = krsDoc.data();
    
    if (krs.userId !== userId) {
      throw new Error('Anda tidak memiliki akses untuk menghapus KRS ini');
    }
    
    if (krs.status === 'approved') {
      throw new Error('KRS yang sudah disetujui tidak dapat dihapus');
    }
    
    // Get jadwal
    const jadwalDoc = await this.jadwalCollection.doc(krs.jadwalId).get();
    
    // Delete KRS
    await krsDoc.ref.delete();
    
    // Update terisi
    if (jadwalDoc.exists) {
      const jadwal = jadwalDoc.data();
      await jadwalDoc.ref.update({
        terisi: Math.max(0, jadwal.terisi - 1),
        updatedAt: new Date(),
      });
    }
    
    return { message: 'KRS berhasil dihapus' };
  }
}

module.exports = new KRSService();
