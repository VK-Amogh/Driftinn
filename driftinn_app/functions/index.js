const { onCall } = require("firebase-functions/v2/https");
const { logger } = require("firebase-functions");
// const admin = require("firebase-admin");

// admin.initializeApp();

/**
 * Verify if an email belongs to a college domain (.edu).
 * TODO: Implement actual OTP generation/sending.
 */
exports.verifyCollegeDomain = onCall((request) => {
    const email = request.data.email;

    if (!email) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            "The function must be called with an email.",
        );
    }

    // Simple regex check for .edu domain
    const isEdu = email.trim().toLowerCase().endsWith(".edu");

    logger.info("Verifying email:", { email, isEdu });

    if (!isEdu) {
        return {
            valid: false,
            message: "Please use a valid .edu college email.",
        };
    }

    // Success path
    // In a real app, here we would generate a random 6-digit code
    // and send it via SendGrid/Nodemailer.
    return {
        valid: true,
        message: "OTP sent to " + email, // Mock success
    };
});

/**
 * Check if a user account exists in Firestore.
 */
exports.accountCheck = onCall(async (request) => {
    // In a real app, we might check request.auth.uid used from the context
    // But for this "pre-login" check or just after acquiring token:
    const uid = request.data.uid;
    const email = request.data.email; // Optional fallback

    if (!uid) {
        return { exists: false, isNew: true };
    }

    // Check Firestore
    // const userDoc = await admin.firestore().collection('users').doc(uid).get();
    // For scaffolding without admin SDK fully configured with service account:
    // We will simulate "New User" for now unless we manually create one.

    // MOCK LOGIN LOGIC:
    // If we want to test "Existing User", we could check hardcoded ID or assume new.
    // Let's assume NEW for now to drive the Onboarding flow as requested.

    return {
        exists: false,
        isNew: true,
        uid: uid
    };
});
