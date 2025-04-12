const admin = require('firebase-admin');
const fs = require('fs');

// Initialize Firebase Admin SDK
const serviceAccount = require('./serviceAccountKey.json'); // Download from Firebase Console

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();
const medicines = JSON.parse(fs.readFileSync('./realistic_medicines_100.json', 'utf8'));

medicines.forEach(async (medicine) => {
  await db.collection('medicines').add(medicine);
  console.log(`Imported: ${medicine.name}`);
});