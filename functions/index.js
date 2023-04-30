const functions = require("firebase-functions");


// const functions = require('firebase-functions');
// const admin = require('firebase-admin');

// admin.initializeApp();

// exports.sendNotificationToAllDevices = functions.https.onCall((data, context) => {
//   // Get the message text from the client-side
//   const messageText = data.messageText;

//   // Construct the notification payload
//   const payload = {
//     notification: {
//       title: 'New Notification',
//       body: messageText
//     }
//   };

//   // Send the notification to all devices subscribed to the topic "all"
//   return admin.messaging().sendToTopic('all', payload);
// });
// // Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});
