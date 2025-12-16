const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');

// Initialize Firebase Admin SDK
const initializeFirebase = () => {
  try {
    // Check if Firebase is already initialized
    if (admin.apps.length > 0) {
      return admin.app();
    }

    // Try to use service account file first
    const serviceAccountPath = path.join(__dirname, '../../serviceAccountKey.json');
    
    if (fs.existsSync(serviceAccountPath)) {
      // Use service account file
      const serviceAccount = require(serviceAccountPath);
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });
      console.log('✅ Firebase Admin initialized with serviceAccountKey.json');
    } else {
      // Fallback to environment variables
      const config = require('./config');
      
      if (!config.firebase.projectId || !config.firebase.clientEmail || !config.firebase.privateKey) {
        throw new Error('Firebase credentials not found. Please add serviceAccountKey.json or set environment variables.');
      }
      
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId: config.firebase.projectId,
          clientEmail: config.firebase.clientEmail,
          privateKey: config.firebase.privateKey.replace(/\\n/g, '\n'),
        }),
      });
      console.log('✅ Firebase Admin initialized with environment variables');
    }

    return admin.app();
  } catch (error) {
    console.error('❌ Firebase initialization error:', error.message);
    console.error('📝 Please either:');
    console.error('   1. Place serviceAccountKey.json in backend/ folder, OR');
    console.error('   2. Set FIREBASE_* variables in .env file');
    throw error;
  }
};

// Initialize Firebase
initializeFirebase();

// Export Firestore database instance
const db = admin.firestore();

// Firestore settings
db.settings({
  ignoreUndefinedProperties: true,
});

module.exports = {
  admin,
  db,
  auth: admin.auth(),
};
