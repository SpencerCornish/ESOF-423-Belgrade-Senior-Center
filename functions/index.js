const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

exports.helloWorld = functions.https.onRequest((request, response) => {
  response.send("Hello from Firebase!");
});

exports.updateUserRoleDefinitions = functions.firestore.document("users/{userDocID}").onWrite((change, context) => {
  // Get an object with the current document value.
  const newDocument = change.after.exists ? change.after.data() : null;

  // Get an object with the previous document value (for update or delete)
  const oldDocument = change.before.exists ? change.before.data() : null;

  // The user has been deleted, so remove their auth role from the respective file
  if (newDocument === null) {
    removeDeletedUser(oldDocument);
    return;
  }
  // This is a new user being added
  if (oldDocument === null) {
    addNewUser(newDocument);
    return;
  }
});

function getFirestore() {
  return admin.firestore();
}

function removeDeletedUser(oldDocument) {
  if (oldDocument === null) {
    console.error("New document and old document both null. I don't know what to do");
    return;
  }

  const oldRole = oldDocument["role"];
  const oldLoginUID = oldDocument["login_uid"];

  let collectionID = "none";
  switch (oldRole) {
    case "admin":
      collectionID = "roles_admin";
      break;
    case "volunteer":
      collectionID = "roles_volunteer";
      break;
    default:
      console.debug("Nothing to do for this deleted user, exiting...");
      return;
  }

  if (collectionID === "none") {
    return;
  }

  db = getFirestore();

  db.collection(collectionID)
    .doc(oldLoginUID)
    .delete();
}


function addNewUser(newDocument) {
  if (newDocument === null) {
    console.error("New document and old document both null. I don't know what to do");
    return;
  }

  const newRole = newDocument["role"];
  const newLoginUID = newDocument["login_uid"];

  let collectionID = "none";
  switch (oldRole) {
    case "admin":
      collectionID = "roles_admin";
      break;
    case "volunteer":
      collectionID = "roles_volunteer";
      break;
    default:
      console.debug("Nothing to do for this deleted user, exiting...");
      return;
  }

  if (collectionID === "none") {
    return;
  }

  db = getFirestore();

  db.collection(collectionID)
    .doc(newLoginUID).set(TODO);
}