/**
 * Load environment variables from .env file
 */
require("dotenv").config();

/**
 * Import Firebase Functions SDK v2
 */
const {onRequest} = require("firebase-functions/v2/https");
const {setGlobalOptions} = require("firebase-functions/v2");

/**
 * Import Firebase Admin SDK
 */
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const admin = require("firebase-admin");

// Initialize Firebase Admin
initializeApp();
const db = getFirestore();

/**
 * Import other necessary modules
 */
const express = require("express");
const axios = require("axios");
const crypto = require("crypto");

const app = express();
app.use(express.json());

const xenditSecretKey = process.env.XENDIT_SECRET_KEY;

/**
 * Global options (set region here)
 */
setGlobalOptions({
  region: "asia-southeast1",
  maxInstances: 10,
});

/**
 * Verify Xendit Webhook Signature
 * Xendit sends the callback token in the X-CALLBACK-TOKEN header
 * We simply compare it with our stored token
 */
function verifyXenditSignature(req) {
  const callbackToken = req.headers["x-callback-token"];
  const expectedToken = process.env.XENDIT_CALLBACK_TOKEN;
  
  console.log("Received callback token:", callbackToken ? "Present" : "Missing");
  console.log("Expected token configured:", expectedToken ? "Yes" : "No");
  
  return callbackToken === expectedToken;
}

/**
 * Export all functions
 */
exports.createPayment = onRequest({timeoutSeconds: 60}, async (req, res) => {
  const {amount, description, customerEmail, external_id, doctorXenditAccountId} = req.body;

  try {
    console.log("Creating payment with data:", {
      amount,
      description,
      customerEmail,
      external_id,
      doctorXenditAccountId: doctorXenditAccountId ? "Present" : "Not provided",
    });

    // Prepare the request payload
    const payload = {
      external_id: external_id || `order_${Date.now()}`,
      amount,
      description,
      payer_email: customerEmail,
      success_redirect_url: "https://example.com/payment-success",
      failure_redirect_url: "https://example.com/payment-failed",
    };

    // If doctorXenditAccountId is provided, add it to the payload
    if (doctorXenditAccountId) {
      payload.recipient = {
        account_id: doctorXenditAccountId,
      };
      console.log("Setting recipient account ID:", doctorXenditAccountId);
    }

    const response = await axios.post(
      "https://api.xendit.co/v2/invoices",
      payload,
      {
        auth: {username: xenditSecretKey, password: ""},
      },
    );

    console.log("Payment created successfully:", response.data);

    res.json({
      invoiceUrl: response.data.invoice_url,
      invoiceId: response.data.id,
    });
  } catch (error) {
    console.error("Payment creation failed:", error);
    if (error.response) {
      console.error("Error response:", error.response.data);
    }
    res.status(500).send("Failed to create payment");
  }
});

exports.webhookPaymentStatus = onRequest({timeoutSeconds: 60}, async (req, res) => {
  try {
    const event = req.body;
    console.log("Received webhook event:", JSON.stringify(event, null, 2));

    if (!verifyXenditSignature(req)) {
      console.warn("Invalid Xendit signature");
      return res.status(403).send("Unauthorized");
    }

    // Check if this is a v3 API webhook
    const isV3Api = req.headers["api-version"] === "v3";
    console.log("API Version:", isV3Api ? "v3" : "v2");

    let externalId, status, invoiceId;

    if (isV3Api) {
      // Handle v3 API format
      console.log("Processing v3 API webhook");
      
      // Check if this is a payment.capture event
      if (event.event === "payment.capture") {
        console.log("Processing payment.capture event");
        const data = event.data;
        externalId = data.reference_id;
        status = data.status;
        invoiceId = data.payment_request_id;
        
        console.log("V3 API - External ID:", externalId);
        console.log("V3 API - Status:", status);
        console.log("V3 API - Invoice ID:", invoiceId);
      } else {
        console.log("Unhandled v3 event type:", event.event);
        return res.status(200).send("Unhandled event type");
      }
    } else {
      // Handle v2 API format
      console.log("Processing v2 API webhook");
      externalId = event.external_id;
      status = event.status;
      invoiceId = event.id;
      
      console.log("V2 API - External ID:", externalId);
      console.log("V2 API - Status:", status);
      console.log("V2 API - Invoice ID:", invoiceId);
    }

    let normalizedStatus = status.toLowerCase();
    if (status === "SETTLED" || status === "PAID" || status === "SUCCEEDED") {
      normalizedStatus = "paid";
    }

    console.log("Normalized status:", normalizedStatus);

    // Fetch payment method details from Xendit
    let paymentMethod = "Xendit";
    let bankCode = null;
    
    if (invoiceId) {
      try {
        const response = await axios.get(
          `https://api.xendit.co/v2/invoices/${invoiceId}`,
          {
            auth: {username: xenditSecretKey, password: ""},
          },
        );
        
        console.log("Xendit invoice details:", response.data);
        
        // Extract payment method from the invoice response
        if (response.data.payment_method) {
          paymentMethod = response.data.payment_method;
          if (response.data.bank_code) {
            bankCode = response.data.bank_code;
            paymentMethod = `${paymentMethod} (${bankCode})`;
          }
        } else if (response.data.payment_channel) {
          // For e-wallet payments
          paymentMethod = response.data.payment_channel;
          if (response.data.payment_method) {
            paymentMethod = `${paymentMethod} (${response.data.payment_method})`;
          }
        }
        
        console.log("Extracted payment method:", paymentMethod);
      } catch (error) {
        console.error("Error fetching Xendit invoice details:", error);
        // Continue with default payment method if fetch fails
      }
    }

    // First try to find the payment document by invoiceId
    let paymentDoc;
    let paymentDocId;
    
    if (invoiceId) {
      console.log("Searching for payment by invoice ID:", invoiceId);
      const querySnapshot = await db.collection("pending_payments")
        .where("invoiceId", "==", invoiceId)
        .limit(1)
        .get();
      
      if (!querySnapshot.empty) {
        paymentDoc = querySnapshot.docs[0];
        paymentDocId = paymentDoc.id;
        console.log("Found payment document by invoice ID:", paymentDocId);
      }
    }
    
    // If not found by invoiceId, try by externalId
    if (!paymentDoc && externalId) {
      console.log("Searching for payment by external ID:", externalId);
      const querySnapshot = await db.collection("pending_payments")
        .where("appointmentId", "==", externalId)
        .limit(1)
        .get();
      
      if (!querySnapshot.empty) {
        paymentDoc = querySnapshot.docs[0];
        paymentDocId = paymentDoc.id;
        console.log("Found payment document by external ID:", paymentDocId);
      }
    }
    
    // If still not found, try direct document lookup
    if (!paymentDoc && externalId) {
      console.log("Trying direct document lookup with ID:", externalId);
      const docRef = db.collection("pending_payments").doc(externalId);
      const doc = await docRef.get();
      
      if (doc.exists) {
        paymentDoc = doc;
        paymentDocId = doc.id;
        console.log("Found payment document by direct lookup:", paymentDocId);
      }
    }
    
    // If we found a payment document, update it
    if (paymentDoc) {
      console.log("Updating payment document:", paymentDocId);
      await db.collection("pending_payments").doc(paymentDocId).update({
        status: normalizedStatus,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        lastWebhookUpdate: event,
        paymentMethod: paymentMethod,
      });
      
      // If this is a paid status, also update the appointment if it exists
      if (normalizedStatus === "paid") {
        const appointmentId = paymentDoc.data().appointmentId;
        if (appointmentId) {
          console.log("Updating appointment status:", appointmentId);
          try {
            await db.collection("appointments").doc(appointmentId).update({
              paymentStatus: "paid",
              paymentUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
              paymentMethod: paymentMethod,
            });
            console.log("Appointment payment status updated successfully");
          } catch (appointmentError) {
            console.error("Error updating appointment status:", appointmentError);
            // Continue processing even if appointment update fails
          }
        }
      }
      
      res.status(200).send("Webhook processed successfully");
    } else {
      console.warn("No matching payment document found for webhook");
      // Create a new document to track this webhook
      const webhookId = `webhook_${Date.now()}`;
      await db.collection("webhook_logs").doc(webhookId).set({
        event: event,
        externalId: externalId,
        invoiceId: invoiceId,
        status: normalizedStatus,
        paymentMethod: paymentMethod,
        receivedAt: admin.firestore.FieldValue.serverTimestamp(),
        processed: false,
        error: "No matching payment document found",
      });
      
      res.status(200).send("Webhook received but no matching payment found");
    }
  } catch (error) {
    console.error("Error processing webhook:", error);
    res.status(500).send("Error processing webhook");
  }
});

exports.createPayout = onRequest({timeoutSeconds: 60}, async (req, res) => {
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

exports.registerDoctorAccount = onRequest({timeoutSeconds: 60}, async (req, res) => {
  try {
    const {doctorId, name, bankCode, bankAccount} = req.body;

    if (!doctorId || !name || !bankCode || !bankAccount) {
      return res.status(400).send({
        error: "Missing required doctor information.",
      });
    }

    const xenditResponse = await axios.post(
      "https://api.xendit.co/accounts",
      {
        type: "MANAGED",
        public_profile: {
          business_name: name,
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
          "Authorization": `Basic ${Buffer.from(`${xenditSecretKey}:`).toString("base64")}`,
        },
      },
    );

    if (xenditResponse.status !== 201 || !xenditResponse.data.id) {
      console.error("Error creating Xendit managed account:", xenditResponse.data);
      return res.status(500).send({
        error: "Failed to create doctor's Xendit account.",
      });
    }

    const xenditAccountId = xenditResponse.data.id;

    await db.collection("doctors").doc(doctorId).set(
      {
        xenditAccountId: xenditAccountId,
        name: name,
        bankCode: bankCode,
        bankAccount: bankAccount,
        registrationDate: admin.firestore.FieldValue.serverTimestamp(),
      },
      {merge: true},
    );

    return res.status(200).send({
      message: "Doctor account registered successfully.",
      xenditAccountId: xenditAccountId,
    });
  } catch (error) {
    console.error("Error in registerDoctorAccount:", error);
    let errorMessage = "Failed to register doctor account.";
    if (error.response?.data?.error) {
      errorMessage = `Failed to register doctor account: ${error.response.data.error}`;
    }
    return res.status(500).send({error: errorMessage});
  }
});

/**
 * 6. Book Appointment and Initiate Payment (HTTP Request - 2nd Gen)
 */
exports.bookAppointmentAndInitiatePayment = onRequest(async (req, res) => {
  // ... logic for booking and initiating payment
  res.status(200).send("Appointment booked and payment initiated");
});

/**
 * 7. Handle Appointment Acceptance (HTTP Request - 2nd Gen)
 */
exports.handleAppointmentAcceptance = onRequest(async (req, res) => {
  // ... logic for accepting appointment
  res.status(200).send("Appointment accepted");
});

/**
 * 8. Handle Appointment Rejection (HTTP Request - 2nd Gen)
 */
exports.handleAppointmentRejection = onRequest(async (req, res) => {
  // ... logic for rejecting appointment and initiating refund
  res.status(200).send("Appointment rejected and refund initiated");
});

/**
 * 9. Initiate Refund (HTTP Request - 2nd Gen)
 */
exports.initiateRefund = onRequest({timeoutSeconds: 60}, async (req, res) => {
  try {
    const {invoiceId, amount, reason, external_id} = req.body;

    // Validate required fields
    if (!invoiceId || !amount || !reason) {
      console.error("Missing required fields for refund");
      return res.status(400).send({
        error: "Missing required fields: invoiceId, amount, and reason are required",
      });
    }

    // Call Xendit API to create refund
    const response = await axios.post(
      `https://api.xendit.co/v2/invoices/${invoiceId}/refunds`,
      {
        amount: amount,
        reason: reason,
        external_id: external_id || `refund_${Date.now()}`,
      },
      {
        auth: {username: xenditSecretKey, password: ""},
      },
    );

    console.log("Refund created successfully:", response.data);

    // Store initial refund record in Firestore
    const refundId = response.data.id;
    const appointmentId = external_id?.replace("refund_", "");

    if (appointmentId) {
      // Create refund record in appointments/refunds subcollection
      await db.collection("appointments")
        .doc(appointmentId)
        .collection("refunds")
        .doc(refundId)
        .set({
          refundId: refundId,
          invoiceId: invoiceId,
          amount: amount,
          reason: reason,
          status: "PENDING",
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

      // Update appointment with initial refund status
      await db.collection("appointments").doc(appointmentId).update({
        refundStatus: "PENDING",
        refundId: refundId,
        refundInitiatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    res.status(200).json(response.data);
  } catch (error) {
    console.error("Error initiating refund:", error);
    
    // Log the error for debugging
    await db.collection("webhook_logs").add({
      type: "refund_initiation",
      event: req.body,
      receivedAt: admin.firestore.FieldValue.serverTimestamp(),
      processed: false,
      error: error.message || "Unknown error",
      stackTrace: error.stack,
    });

    res.status(500).send({
      error: "Failed to initiate refund",
      details: error.message || "Unknown error",
    });
  }
});

/**
 * 10. Handle Refund Webhook (HTTP Request - 2nd Gen)
 */
exports.webhookRefundStatus = onRequest({timeoutSeconds: 60}, async (req, res) => {
  try {
    console.log("=== Processing Refund Webhook ===");
    console.log("Request body:", JSON.stringify(req.body, null, 2));

    if (!verifyXenditSignature(req)) {
      console.warn("Invalid Xendit signature");
      return res.status(403).send("Unauthorized");
    }

    const event = req.body;
    const eventType = event.event;
    const refundData = event.data;
    
    if (!refundData) {
      console.error("No refund data found in webhook");
      return res.status(400).send("No refund data found");
    }

    const refundId = refundData.id;
    const status = refundData.status;
    const invoiceId = refundData.invoice_id;
    const amount = parseFloat(refundData.amount);
    let appointmentId = refundData.reference_id?.replace("refund_", "");

    console.log("Processing refund:", {
      refundId,
      status,
      appointmentId,
      invoiceId,
      amount,
      eventType,
    });

    // First, try to find the appointment by invoice ID in pending_payments
    const pendingPaymentQuery = await db
      .collection("pending_payments")
      .where("invoiceId", "==", invoiceId)
      .limit(1)
      .get();

    if (!pendingPaymentQuery.empty) {
      const pendingPayment = pendingPaymentQuery.docs[0].data();
      appointmentId = pendingPayment.appointmentId;
      console.log("Found appointment ID from pending_payments:", appointmentId);
    }

    if (!appointmentId) {
      console.error("No appointment ID found in refund data");
      // Log the error but don't return 400 - we want to acknowledge the webhook
      await db.collection("webhook_logs").add({
        type: "refund_webhook",
        event: req.body,
        receivedAt: admin.firestore.FieldValue.serverTimestamp(),
        processed: false,
        error: "No appointment ID found",
        refundId,
        invoiceId,
        status,
      });
      return res.status(200).send("OK - No appointment found");
    }

    // Verify appointment exists
    const appointmentRef = db.collection("appointments").doc(appointmentId);
    const appointmentDoc = await appointmentRef.get();

    if (!appointmentDoc.exists) {
      console.error("Appointment document not found:", appointmentId);
      await db.collection("webhook_logs").add({
        type: "refund_webhook",
        event: req.body,
        receivedAt: admin.firestore.FieldValue.serverTimestamp(),
        processed: false,
        error: "Appointment document not found",
        appointmentId,
        refundId,
        invoiceId,
        status,
      });
      return res.status(200).send("OK - Appointment not found");
    }

    // Start a batch write to ensure all updates are atomic
    const batch = db.batch();

    // Update appointment document
    batch.update(appointmentRef, {
      "refundStatus": status,
      "refundUpdatedAt": admin.firestore.FieldValue.serverTimestamp(),
      "refundAmount": amount,
    });

    // Update refund record
    const refundRef = db
      .collection("appointments")
      .doc(appointmentId)
      .collection("refunds")
      .doc(refundId);

    batch.update(refundRef, {
      "status": status,
      "updatedAt": admin.firestore.FieldValue.serverTimestamp(),
      "amount": amount,
      "webhookData": event,
      "failureCode": refundData.failure_code,
      "refundFeeAmount": refundData.refund_fee_amount,
    });

    // Update payment in pending_payments collection
    if (!pendingPaymentQuery.empty) {
      const pendingPaymentRef = pendingPaymentQuery.docs[0].ref;
      batch.update(pendingPaymentRef, {
        "refundStatus": status,
        "refundUpdatedAt": admin.firestore.FieldValue.serverTimestamp(),
        "refundAmount": amount,
      });
    }

    // Update payment in appointments/payments subcollection
    const appointmentPaymentQuery = await db
      .collection("appointments")
      .doc(appointmentId)
      .collection("payments")
      .where("invoiceId", "==", invoiceId)
      .limit(1)
      .get();

    if (!appointmentPaymentQuery.empty) {
      const appointmentPaymentRef = appointmentPaymentQuery.docs[0].ref;
      batch.update(appointmentPaymentRef, {
        "refundStatus": status,
        "refundUpdatedAt": admin.firestore.FieldValue.serverTimestamp(),
        "refundAmount": amount,
      });
    }

    // Commit the batch
    await batch.commit();

    console.log("Refund status updated successfully");
    return res.status(200).send("OK");
  } catch (error) {
    console.error("Error processing refund webhook:", error);
    // Log the error for debugging
    await db.collection("webhook_logs").add({
      type: "refund_webhook",
      event: req.body,
      receivedAt: admin.firestore.FieldValue.serverTimestamp(),
      processed: false,
      error: error.message || "Unknown error",
      stackTrace: error.stack,
    });
    return res.status(200).send("OK - Error logged"); // Return 200 to acknowledge webhook
  }
});

/**
 * 11. Handle Invoice Paid Webhook (HTTP Request - 2nd Gen)
 */
exports.webhookInvoicePaid = onRequest(async (req, res) => {
  // ... logic to handle invoice paid webhook
  res.status(200).send("Invoice paid webhook received");
});

/**
 * 12. Handle E-Wallet Disbursement Webhook (HTTP Request - 2nd Gen)
 */
exports.webhookEwalletDisbursement = onRequest(async (req, res) => {
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

/**
 * 13. Get Webhook Logs (HTTP Request - 2nd Gen)
 * This function retrieves webhook logs for debugging purposes
 */
exports.getWebhookLogs = onRequest(async (req, res) => {
  try {
    // Check for authentication (you should implement proper authentication)
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).send("Unauthorized");
    }
    
    const token = authHeader.split("Bearer ")[1];
    // In a real implementation, you would verify this token against your admin tokens
    
    // Get query parameters
    const limit = parseInt(req.query.limit) || 50;
    const offset = parseInt(req.query.offset) || 0;
    const status = req.query.status || null;
    const startDate = req.query.startDate ? new Date(req.query.startDate) : null;
    const endDate = req.query.endDate ? new Date(req.query.endDate) : null;
    
    // Build the query
    let query = db.collection("webhook_logs").orderBy("receivedAt", "desc");
    
    // Apply filters if provided
    if (status) {
      query = query.where("status", "==", status);
    }
    
    if (startDate) {
      query = query.where("receivedAt", ">=", startDate);
    }
    
    if (endDate) {
      query = query.where("receivedAt", "<=", endDate);
    }
    
    // Execute the query with pagination
    const snapshot = await query.limit(limit).offset(offset).get();
    
    // Format the results
    const logs = snapshot.docs.map(doc => {
      const data = doc.data();
      return {
        id: doc.id,
        ...data,
        receivedAt: data.receivedAt ? data.receivedAt.toDate().toISOString() : null,
      };
    });
    
    // Get the total count for pagination
    const totalCount = (await query.count().get()).data().count;
    
    res.status(200).json({
      logs,
      pagination: {
        total: totalCount,
        limit,
        offset,
        hasMore: offset + logs.length < totalCount,
      },
    });
  } catch (error) {
    console.error("Error retrieving webhook logs:", error);
    res.status(500).send("Error retrieving webhook logs");
  }
});

/**
 * 14. Retry Failed Webhooks (HTTP Request - 2nd Gen)
 * This function allows retrying failed webhook processing
 */
exports.retryFailedWebhooks = onRequest(async (req, res) => {
  try {
    // Check for authentication (you should implement proper authentication)
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).send("Unauthorized");
    }
    
    const token = authHeader.split("Bearer ")[1];
    // In a real implementation, you would verify this token against your admin tokens
    
    // Get the webhook ID to retry
    const {webhookId} = req.body;
    if (!webhookId) {
      return res.status(400).send("Missing webhookId parameter");
    }
    
    // Get the webhook log
    const webhookDoc = await db.collection("webhook_logs").doc(webhookId).get();
    if (!webhookDoc.exists) {
      return res.status(404).send("Webhook log not found");
    }
    
    const webhookData = webhookDoc.data();
    
    // Check if this is a payment webhook
    if (webhookData.event && (webhookData.event.event === "payment.capture" || webhookData.event.status)) {
      // Create a mock request object with the webhook data
      const mockReq = {
        body: webhookData.event,
        headers: {
          "x-callback-token": process.env.XENDIT_CALLBACK_TOKEN,
          "api-version": webhookData.event.event ? "v3" : "v2",
        },
      };
      
      // Create a mock response object
      const mockRes = {
        status: function(code) {
          this.statusCode = code;
          return this;
        },
        send: function(message) {
          this.message = message;
          return this;
        },
      };
      
      // Call the webhook handler function
      await exports.webhookPaymentStatus(mockReq, mockRes);
      
      // Update the webhook log
      await db.collection("webhook_logs").doc(webhookId).update({
        processed: true,
        processedAt: admin.firestore.FieldValue.serverTimestamp(),
        retryCount: admin.firestore.FieldValue.increment(1),
        lastError: null,
      });
      
      return res.status(200).json({
        success: true,
        message: "Webhook processed successfully",
        statusCode: mockRes.statusCode,
        response: mockRes.message,
      });
    } else {
      return res.status(400).send("Unsupported webhook type for retry");
    }
  } catch (error) {
    console.error("Error retrying webhook:", error);
    res.status(500).send("Error retrying webhook");
  }
});

/**
 * Process Refund (HTTP Request - 2nd Gen)
 * This function processes a refund for a paid invoice
 */
exports.processRefund = onRequest({timeoutSeconds: 60}, async (req, res) => {
  try {
    console.log("=== Processing Refund ===");
    console.log("Request body:", JSON.stringify(req.body, null, 2));

    const {invoiceId, amount, reason, external_id} = req.body;

    // Validate required fields
    if (!invoiceId || !amount || !reason) {
      console.error("Missing required fields for refund");
      return res.status(400).send({
        error: "Missing required fields: invoiceId, amount, and reason are required",
      });
    }

    // Call Xendit API to create refund
    const response = await axios.post(
      `https://api.xendit.co/v2/invoices/${invoiceId}/refunds`,
      {
        amount: amount,
        reason: reason,
        external_id: external_id || `refund_${Date.now()}`,
      },
      {
        auth: {username: xenditSecretKey, password: ""},
      },
    );

    console.log("Refund created successfully:", response.data);

    // Store initial refund record in Firestore
    const refundId = response.data.id;
    const appointmentId = external_id?.replace("refund_", "");

    if (appointmentId) {
      // Create refund record in appointments/refunds subcollection
      await db.collection("appointments")
        .doc(appointmentId)
        .collection("refunds")
        .doc(refundId)
        .set({
          refundId: refundId,
          invoiceId: invoiceId,
          amount: amount,
          reason: reason,
          status: "PENDING",
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

      // Update appointment with initial refund status
      await db.collection("appointments").doc(appointmentId).update({
        refundStatus: "PENDING",
        refundId: refundId,
        refundInitiatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Update payment in pending_payments collection
      const pendingPaymentQuery = await db
        .collection("pending_payments")
        .where("invoiceId", "==", invoiceId)
        .limit(1)
        .get();

      if (!pendingPaymentQuery.empty) {
        const pendingPaymentRef = pendingPaymentQuery.docs[0].ref;
        await pendingPaymentRef.update({
          refundStatus: "PENDING",
          refundId: refundId,
          refundInitiatedAt: admin.firestore.FieldValue.serverTimestamp(),
          refundAmount: amount,
          refundReason: reason,
        });
      }
    }

    res.status(200).json(response.data);
  } catch (error) {
    console.error("Error processing refund:", error);
    
    // Log the error for debugging
    await db.collection("webhook_logs").add({
      type: "refund_processing",
      event: req.body,
      receivedAt: admin.firestore.FieldValue.serverTimestamp(),
      processed: false,
      error: error.message || "Unknown error",
      stackTrace: error.stack,
    });

    res.status(500).send({
      error: "Failed to process refund",
      details: error.message || "Unknown error",
    });
  }
});