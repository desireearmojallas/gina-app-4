/**
 * Import Firebase Functions SDK v2
 */
import {onRequest} from "firebase-functions/v2/https";
import {setGlobalOptions} from "firebase-functions/v2";

/**
 * Import Firebase Admin SDK
 */
import {initializeApp} from "firebase-admin/app";
/**
 * To use later
 */
// import * as admin from "firebase-admin";
initializeApp();

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
  console.log("Received webhook:", event);

  // Handle different status cases
  if (event.status === "PAID") {
    console.log(`Payment successful for ${event.external_id}`);
  } else if (event.status === "FAILED") {
    console.log(`Payment failed for ${event.external_id}`);
  }

  res.sendStatus(200);
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
