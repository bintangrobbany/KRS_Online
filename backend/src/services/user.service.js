const { db } = require('../config/firebase');

class UserService {
  constructor() {
    this.usersCollection = db.collection('users');
    this.savedClassesCollection = db.collection('saved_classes');
    this.notificationsCollection = db.collection('notifications');
    this.jadwalCollection = db.collection('jadwal');
    this.mataKuliahCollection = db.collection('mata_kuliah');
  }

  async updateProfile(userId, updates) {
    const { name, phoneNumber, photoUrl } = updates;
    
    const updateData = {
      updatedAt: new Date(),
    };
    
    if (name) updateData.name = name;
    if (phoneNumber) updateData.phoneNumber = phoneNumber;
    if (photoUrl) updateData.photoUrl = photoUrl;
    
    await this.usersCollection.doc(userId).update(updateData);
    
    const userDoc = await this.usersCollection.doc(userId).get();
    const user = { id: userDoc.id, ...userDoc.data() };
    
    // Remove password from response
    delete user.password;
    
    return user;
  }
  
  async getSavedClasses(userId) {
    const snapshot = await this.savedClassesCollection
      .where('userId', '==', userId)
      .orderBy('createdAt', 'desc')
      .get();
    
    const savedClasses = [];
    for (const doc of snapshot.docs) {
      const savedData = { id: doc.id, ...doc.data() };
      
      // Get jadwal details
      const jadwalDoc = await this.jadwalCollection.doc(savedData.jadwalId).get();
      if (jadwalDoc.exists) {
        const jadwalData = { id: jadwalDoc.id, ...jadwalDoc.data() };
        
        // Get mata kuliah details
        const mkDoc = await this.mataKuliahCollection.doc(jadwalData.mataKuliahId).get();
        if (mkDoc.exists) {
          jadwalData.mataKuliah = { id: mkDoc.id, ...mkDoc.data() };
        }
        
        savedData.jadwal = jadwalData;
      }
      
      savedClasses.push(savedData);
    }
    
    return savedClasses;
  }
  
  async saveClass(userId, jadwalId) {
    // Check if already saved
    const existingSnapshot = await this.savedClassesCollection
      .where('userId', '==', userId)
      .where('jadwalId', '==', jadwalId)
      .get();
    
    if (!existingSnapshot.empty) {
      throw new Error('Kelas sudah disimpan sebelumnya');
    }
    
    // Create saved class
    const savedRef = this.savedClassesCollection.doc();
    const savedData = {
      id: savedRef.id,
      userId,
      jadwalId,
      createdAt: new Date(),
    };
    
    await savedRef.set(savedData);
    
    // Get jadwal details
    const jadwalDoc = await this.jadwalCollection.doc(jadwalId).get();
    if (jadwalDoc.exists) {
      const jadwalData = { id: jadwalDoc.id, ...jadwalDoc.data() };
      
      // Get mata kuliah details
      const mkDoc = await this.mataKuliahCollection.doc(jadwalData.mataKuliahId).get();
      if (mkDoc.exists) {
        jadwalData.mataKuliah = { id: mkDoc.id, ...mkDoc.data() };
      }
      
      savedData.jadwal = jadwalData;
    }
    
    return savedData;
  }
  
  async unsaveClass(userId, jadwalId) {
    const snapshot = await this.savedClassesCollection
      .where('userId', '==', userId)
      .where('jadwalId', '==', jadwalId)
      .get();
    
    if (snapshot.empty) {
      throw new Error('Kelas tidak ditemukan di daftar simpanan');
    }
    
    // Delete all matches (should be only one)
    const batch = db.batch();
    snapshot.docs.forEach((doc) => {
      batch.delete(doc.ref);
    });
    await batch.commit();
    
    return { message: 'Kelas berhasil dihapus dari simpanan' };
  }
  
  async getNotifications(userId) {
    const snapshot = await this.notificationsCollection
      .where('userId', '==', userId)
      .orderBy('createdAt', 'desc')
      .get();
    
    return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
  }
  
  async markNotificationAsRead(userId, notificationId) {
    const notifDoc = await this.notificationsCollection.doc(notificationId).get();
    
    if (!notifDoc.exists) {
      throw new Error('Notifikasi tidak ditemukan');
    }
    
    const notif = notifDoc.data();
    
    if (notif.userId !== userId) {
      throw new Error('Notifikasi tidak ditemukan');
    }
    
    await notifDoc.ref.update({
      isRead: true,
    });
    
    return { id: notifDoc.id, ...notifDoc.data(), isRead: true };
  }
}

module.exports = new UserService();
