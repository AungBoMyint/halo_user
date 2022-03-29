/* eslint-disable */

const admin = require("firebase-admin");
admin.initializeApp();
const functions = require("firebase-functions");

async function grantPartnerUser(email) {
    const user = await admin.auth().getUserByEmail(email);
    if (user.customClaims && user.customClaims.isPartnerUser === true) {
        return;
    }
    return admin.auth().setCustomUserClaims(user.uid, {
        isPartnerUser: true,
    });
}

async function grantAdminUser(phone) {
    const user = await admin.auth().getUserByPhoneNumber(phone);
    if (user.customClaims && user.customClaims.isAdminUser === true) {
        return;
    }
    return admin.auth().setCustomUserClaims(user.uid, {
        isAdminUser: true,
    });
}

exports.createAdminUserWithPhoneNumber = functions.region("asia-southeast2").https.onCall(async (data, context) => {
    return grantAdminUser(data.phone);
});

exports.createPartnerAccount = functions.region("asia-southeast2").https.onCall(
    async (data, context) => {
        admin.auth().createUser({
            email: data.email,
            password: data.password,
        }).then((userRecord) => {
            grantPartnerUser(userRecord.email);
        });
    }
);

exports.getUsers = functions.region("asia-southeast2").https.onCall(
    async (data, context) => {
        // List batch of users, 1000 at a time.
        var allUsers = [];

        return admin.auth().listUsers()
            .then(function (listUsersResult) {
                listUsersResult.users.forEach(function (userRecord) {
                    // For each user
                    var userData = userRecord.toJSON();
                    allUsers.push(userData);
                });

                return JSON.stringify(allUsers);
            })
            .catch(function (error) {
                console.log("Error listing users:", error);
                res.status(500).send(error);
            });
    });
