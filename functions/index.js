/**
 * Load environment variables from .env file
 */
import "dotenv/config";

/**
 * Import Firebase Functions SDK v2
 */
import {onRequest} from "firebase-functions/v2/https";
import {setGlobalOptions} from "firebase-functions/v2";

/**
 * Import Firebase Admin SDK
 */
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
/**
 * To use later
 */
import * as admin from "firebase-admin";
initializeApp();
const db = getFirestore();


/**
 * Import other necessary modules
 */
import express from "express";
import axios from "axios";

const app = express();
app.use(express.json());

const xenditSecretKey = process.env.XENDIT_SECRET_KEY;

/**
 * Global options (set region here)
 */
setGlobalOptions({region: "asia-southeast1"});

/**
 * 1. Create Payment (HTTP Request - 2nd Gen)
 */
export const createPayment = onRequest(async (req, res) => {
  const {amount, description, customerEmail} = req.body;

  try {
    const response = await axios.post(
        "https://api.xendit.co/v2/invoices",
        {
          external_id: `order_${Date.now()}`,
          amount,
          description,
          payer_email: customerEmail,
          success_redirect_url: "https://example.com/payment-success",
          failure_redirect_url: "https://example.com/payment-failed",
        },
        {
          auth: {username: xenditSecretKey, password: ""},
        },
    );

    res.json({invoiceUrl: response.data.invoice_url});
  } catch (error) {
    console.error("Payment creation failed:", error);
    res.status(500).send("Failed to create payment");
  }
});

/**
 * 2. Handle Xendit Webhook for Payment Status Updates (HTTP Request - 2nd Gen)
 */
export const webhookPaymentStatus = onRequest((req, res) => {
  const event = req.body;
  console.log("Received webhook event:", event);

  // Handle different status cases
  if (event.status === "PAID") {
    console.log(`Payment successful for invoice: ${event.id}`);
    // Handle successful payment logic here
  } else if (event.status === "EXPIRED") {
    console.log(`Invoice expired: ${event.id}`);
    // Handle expired invoice logic here
  } else if (event.status === "SETTLED_AFTER_EXPIRY") {
    console.log(`Late payment received for expired invoice: ${event.id}`);
    // Handle late payments here
  } else if (event.status === "FAILED") {
    console.log(`Payment failed for ${event.external_id}`);
  } else {
    console.log(`Unhandled event status: ${event.status}`);
  }

  // Always respond with 200 to acknowledge receipt
  res.status(200).send("Webhook received");
});

/**
 * 3. Create Payout to Doctor's Managed Account (HTTP Request - 2nd Gen)
 */
export const createPayout = onRequest(async (req, res) => {
  const {amount, doctorAccountId, description} = req.body;

  try {
    const response = await axios.post(
        "https://api.xendit.co/payouts",
        {
          external_id: `payout_${Date.now()}`,
          amount,
          description,
          destination: doctorAccountId,
        },
        {
          auth: {username: xenditSecretKey, password: ""},
        },
    );

    res.json(response.data);
  } catch (error) {
    console.error("Payout creation failed:", error);
    res.status(500).send("Failed to create payout");
  }
});

/**
 * 4. Verify Xendit Webhook Signature (Optional but Recommended)
 * @param {Object} req - The request object from Firebase Functions
 * @return {boolean} - Returns true if the signature is valid, false otherwise
 */
function verifyXenditSignature(req) {
  const crypto = require("crypto");
  const signature = req.headers["x-callback-token"];
  const payload = JSON.stringify(req.body);

  const hash = crypto
      .createHmac("sha256", process.env.XENDIT_CALLBACK_TOKEN)
      .update(payload)
      .digest("hex");

  return hash === signature;
}

export const secureWebhook = onRequest((req, res) => {
  if (!verifyXenditSignature(req)) {
    console.warn("Invalid Xendit signature");
    return res.status(403).send("Unauthorized");
  }

  console.log("Valid Xendit Webhook received");
  res.status(200).end();
});

/**
 * 5. Register Doctor Account (HTTP Request - 2nd Gen)
 */
export const registerDoctorAccount = onRequest(async (req, res) => {
  try {
    const {doctorId, name, bankCode, bankAccount} = req.body;

    // Validate input data
    if (!doctorId || !name || !bankCode || !bankAccount) {
      return res.status(400).send({
        error: "Missing required doctor information.",
      });
    }

    // Call Xendit API to create a managed sub-account
    const xenditResponse = await axios.post(
        "https://api.xendit.co/accounts",
        {
          type: "MANAGED",
          public_profile: {
            business_name: name, // Use doctor's name as business name
          },
          individual_profile: {
            account_holder_name: name,
          },
          bank_account: {
            bank_code: bankCode,
            account_number: bankAccount,
          },
        },
        {
          headers: {
            "Content-Type": "application/json",
            "Authorization": `Basic ${Buffer.from(`${xenditSecretKey}:`)
                .toString("base64")}`,
          },
        },
    );

    if (xenditResponse.status !== 201 || !xenditResponse.data.id) {
      console.error(
          "Error creating Xendit managed account:", xenditResponse.data,
      );
      return res.status(500).send({
        error: "Failed to create doctor's Xendit account.",
      });
    }

    const xenditAccountId = xenditResponse.data.id;

    // Store the Xendit account ID in your Firebase database
    const doctorRef = db.collection("doctors").doc(doctorId);
    await doctorRef.set(
        {
          xenditAccountId: xenditAccountId,
          name: name,
          bankCode: bankCode,
          bankAccount: bankAccount,
          registrationDate: admin.firestore.FieldValue.serverTimestamp(),
        },
        {merge: true}, // Use merge to avoid overwriting other doctor data
    );

    console.log(`Doctor ${doctorId} registered with Xendit account ID: ` +
        `${xenditAccountId}`);
    return res.status(200).send({
      message: "Doctor account registered successfully.",
      xenditAccountId: xenditAccountId,
    });
  } catch (error) {
    console.error("Error in registerDoctorAccount:", error);
    let errorMessage = "Failed to register doctor account.";
    if (error.response && error.response.data && error.response.data.error) {
      errorMessage = `Failed to register doctor account: ` +
          `${error.response.data.error}`;
    }
    return res.status(500).send({error: errorMessage});
  }
});

/**
 * 6. Book Appointment and Initiate Payment (HTTP Request - 2nd Gen)
 */
export const bookAppointmentAndInitiatePayment = onRequest(async (req, res) => {
  // ... logic for booking and initiating payment
  res.status(200).send("Appointment booked and payment initiated");
});

/**
 * 7. Handle Appointment Acceptance (HTTP Request - 2nd Gen)
 */
export const handleAppointmentAcceptance = onRequest(async (req, res) => {
  // ... logic for accepting appointment
  res.status(200).send("Appointment accepted");
});

/**
 * 8. Handle Appointment Rejection (HTTP Request - 2nd Gen)
 */
export const handleAppointmentRejection = onRequest(async (req, res) => {
  // ... logic for rejecting appointment and initiating refund
  res.status(200).send("Appointment rejected and refund initiated");
});

/**
 * 9. Initiate Refund (HTTP Request - 2nd Gen)
 */
export const initiateRefund = onRequest(async (req, res) => {
  // ... logic to initiate refund via Xendit
  res.status(200).send("Refund initiated");
});

/**
 * 10. Handle Refund Webhook (HTTP Request - 2nd Gen)
 */
export const webhookRefundStatus = onRequest(async (req, res) => {
  // ... logic to handle refund webhook
  res.status(200).send("Refund webhook received");
});

/**
 * 11. Handle Invoice Paid Webhook (HTTP Request - 2nd Gen)
 */
export const webhookInvoicePaid = onRequest(async (req, res) => {
  // ... logic to handle invoice paid webhook
  res.status(200).send("Invoice paid webhook received");
});

/**
 * 12. Handle E-Wallet Disbursement Webhook (HTTP Request - 2nd Gen)
 */
export const webhookEwalletDisbursement = onRequest(async (req, res) => {
  // Verify webhook signature for security
  if (!verifyXenditSignature(req)) {
    console.warn("Invalid Xendit signature");
    return res.status(403).send("Unauthorized");
  }

  const event = req.body;
  console.log("Received e-wallet disbursement webhook:", event);

  try {
    // Handle different e-wallet disbursement statuses
    switch (event.status) {
      case "SUCCESS":
        // eslint-disable-next-line max-len
        console.log(`E-wallet disbursement successful for reference: ${event.reference_id}`);
        // Update transaction status in your database
        await db.collection("transactions").doc(event.reference_id).update({
          status: "SUCCESS",
          completedAt: admin.firestore.FieldValue.serverTimestamp(),
          disbursementDetails: event,
        });
        break;

      case "FAILED":
        // eslint-disable-next-line max-len
        console.log(`E-wallet disbursement failed for reference: ${event.reference_id}`);
        await db.collection("transactions").doc(event.reference_id).update({
          status: "FAILED",
          failureReason: event.failure_reason || "Unknown error",
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          disbursementDetails: event,
        });
        break;

      case "PENDING":
        // eslint-disable-next-line max-len
        console.log(`E-wallet disbursement pending for reference: ${event.reference_id}`);
        await db.collection("transactions").doc(event.reference_id).update({
          status: "PENDING",
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          disbursementDetails: event,
        });
        break;

      default:
        console.log(`Unhandled e-wallet disbursement status: ${event.status}`);
    }

    res.status(200).send("Webhook processed successfully");
  } catch (error) {
    console.error("Error processing e-wallet disbursement webhook:", error);
    res.status(500).send("Error processing webhook");
  }
});
