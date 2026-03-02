const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.onSosCreated = functions.firestore
  .document('sos_events/{eventId}')
  .onCreate(async (snap, context) => {
    const event = snap.data();
    const eventId = context.params.eventId;

    const uid = event.uid;
    const userName = event.userName || 'RunSOS user';
    const mapsUrl = event.mapsUrl || '';

    // Read emergency contacts for the sender.
    const contactsSnap = await admin
      .firestore()
      .collection('users')
      .doc(uid)
      .collection('emergencyContacts')
      .get();

    const contactPhones = contactsSnap.docs
      .map((d) => (d.data().phoneNumber || '').toString())
      .filter(Boolean);

    if (contactPhones.length === 0) {
      return null;
    }

    // Resolve which contacts are also RunSOS users.
    const contactUids = [];
    for (const phone of contactPhones) {
      const idx = await admin.firestore().collection('phone_index').doc(phone).get();
      const contactUid = idx.exists ? idx.data().uid : null;
      if (contactUid) {
        contactUids.push(contactUid);
      }
    }

    if (contactUids.length === 0) {
      return null;
    }

    // Collect FCM tokens.
    const tokens = [];
    for (const contactUid of contactUids) {
      const tokenSnap = await admin
        .firestore()
        .collection('users')
        .doc(contactUid)
        .collection('fcmTokens')
        .get();

      tokenSnap.docs.forEach((d) => tokens.push(d.id));
    }

    if (tokens.length === 0) {
      return null;
    }

    const payload = {
      notification: {
        title: 'SOS: ' + userName,
        body: mapsUrl ? ('Live location: ' + mapsUrl) : 'Open RunSOS to view live location.'
      },
      data: {
        type: 'sos',
        trackUid: uid,
        sosId: eventId
      }
    };

    await admin.messaging().sendEachForMulticast({
      tokens,
      ...payload
    });

    return null;
  });
