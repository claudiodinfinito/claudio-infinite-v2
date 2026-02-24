# STRIPE.md - Stripe Payment Integration Reference

_Complete guide for Stripe integrations. Based on official Stripe documentation._

---

## 🎯 Quick Start

### Installation

```bash
npm install stripe
```

### Environment Setup

```bash
STRIPE_SECRET_KEY=sk_test_...     # Test mode
STRIPE_PUBLISHABLE_KEY=pk_test_... # Client-side
STRIPE_WEBHOOK_SECRET=whsec_...    # Webhook signing
```

### Basic Integration (Checkout Sessions)

```typescript
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

// Create Checkout Session
const session = await stripe.checkout.sessions.create({
  payment_method_types: ['card'],
  line_items: [{
    price_data: {
      currency: 'usd',
      product_data: { name: 'Product Name' },
      unit_amount: 2000, // $20.00 in cents
    },
    quantity: 1,
  }],
  mode: 'payment',
  success_url: 'https://example.com/success',
  cancel_url: 'https://example.com/cancel',
});

// Redirect to session.url
```

---

## 📚 Core Concepts

### 1. Checkout Sessions API (Recommended)

**Primary backend object for most integrations.**

| Feature | Status |
|---------|--------|
| One-time payments | ✅ |
| Subscriptions | ✅ |
| Multiple payment methods | ✅ (40+) |
| Tax calculation | ✅ Built-in |
| Adaptive Pricing | ✅ Local currency |

**Two UI Modes:**

| Mode | Use Case |
|------|----------|
| **Stripe-hosted** | Redirect to Stripe page (simplest) |
| **Embedded form** | Embed in your site (no redirect) |

**Example: Stripe-hosted**

```typescript
const session = await stripe.checkout.sessions.create({
  mode: 'payment',
  line_items: [...],
  success_url: `${domain}/success?session_id={CHECKOUT_SESSION_ID}`,
  cancel_url: `${domain}/cancel`,
});
```

**Example: Embedded**

```typescript
const session = await stripe.checkout.sessions.create({
  mode: 'payment',
  line_items: [...],
  ui_mode: 'embedded',
  return_url: `${domain}/return?session_id={CHECKOUT_SESSION_ID}`,
});
```

---

### 2. Payment Intents API

**Use ONLY when user explicitly asks.** Checkout Sessions is preferred.

**When to use Payment Intents:**
- Complex custom payment flows
- Need direct control over payment lifecycle
- Building your own checkout UI from scratch

**Lifecycle:**

```
requires_payment_method
         ↓
    [confirm] 
         ↓
requires_confirmation → requires_action → processing
         ↓
    [succeeded/canceled/failed]
```

**Create:**

```typescript
const paymentIntent = await stripe.paymentIntents.create({
  amount: 2000,
  currency: 'usd',
  automatic_payment_methods: { enabled: true },
});
```

**Client-side (with client_secret):**

```javascript
const stripe = Stripe(publishableKey);
const { error } = await stripe.confirmPayment({
  elements,
  confirmParams: { return_url: window.location.origin + '/success' },
});
```

---

### 3. Subscriptions

**Create subscription:**

```typescript
const subscription = await stripe.subscriptions.create({
  customer: 'cus_xxx',
  items: [{ price: 'price_xxx' }],
  payment_behavior: 'default_incomplete',
  payment_settings: { save_default_payment_method: 'on_subscription' },
  expand: ['latest_invoice.payment_intent'],
});
```

**Subscription statuses:**

| Status | Description |
|--------|-------------|
| `active` | Paid and ongoing |
| `past_due` | Payment failed |
| `canceled` | Ended |
| `incomplete` | Initial payment failed |
| `trialing` | Free trial period |
| `unpaid` | Payment failed, retries exhausted |

---

### 4. Webhooks

**Essential for async events:**

```typescript
import Stripe from 'stripe';
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

// Webhook handler (Node.js/Express)
app.post('/webhook', express.raw({ type: 'application/json' }), (req, res) => {
  const sig = req.headers['stripe-signature'] as string;
  const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET!;
  
  let event: Stripe.Event;
  
  try {
    event = stripe.webhooks.constructEvent(req.body, sig, webhookSecret);
  } catch (err: any) {
    console.log(`Webhook Error: ${err.message}`);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }
  
  // Handle event
  switch (event.type) {
    case 'checkout.session.completed':
      const session = event.data.object as Stripe.Checkout.Session;
      // Payment successful
      break;
    case 'payment_intent.succeeded':
      const paymentIntent = event.data.object as Stripe.PaymentIntent;
      // Payment succeeded
      break;
    case 'invoice.paid':
      const invoice = event.data.object as Stripe.Invoice;
      // Subscription payment succeeded
      break;
    case 'invoice.payment_failed':
      const failedInvoice = event.data.object as Stripe.Invoice;
      // Subscription payment failed
      break;
  }
  
  res.status(200).json({ received: true });
});
```

**Common webhook events:**

| Event | When |
|-------|------|
| `checkout.session.completed` | Checkout finished |
| `payment_intent.succeeded` | Payment succeeded |
| `payment_intent.payment_failed` | Payment failed |
| `invoice.paid` | Invoice paid |
| `invoice.payment_failed` | Invoice payment failed |
| `customer.subscription.created` | New subscription |
| `customer.subscription.updated` | Subscription changed |
| `customer.subscription.deleted` | Subscription canceled |

---

### 5. Customers

**Create customer:**

```typescript
const customer = await stripe.customers.create({
  email: 'customer@example.com',
  name: 'Customer Name',
  metadata: { user_id: '123' },
});
```

**Attach payment method:**

```typescript
await stripe.paymentMethods.attach('pm_xxx', {
  customer: 'cus_xxx',
});
```

**Set default payment method:**

```typescript
await stripe.customers.update('cus_xxx', {
  invoice_settings: {
    default_payment_method: 'pm_xxx',
  },
});
```

---

### 6. Products & Prices

**Create product:**

```typescript
const product = await stripe.products.create({
  name: 'Product Name',
  description: 'Product description',
});
```

**Create price:**

```typescript
const price = await stripe.prices.create({
  product: 'prod_xxx',
  unit_amount: 2000, // $20.00
  currency: 'usd',
  recurring: { interval: 'month' }, // For subscriptions
});
```

**One-time vs Recurring:**

| Type | `recurring` | Use Case |
|------|-------------|----------|
| One-time | Omit | Single purchase |
| Subscription | Required | Recurring billing |

---

## 🔑 Key Patterns

### Client Secret Pattern

**Server:**

```typescript
const paymentIntent = await stripe.paymentIntents.create({
  amount: 2000,
  currency: 'usd',
});

return { clientSecret: paymentIntent.client_secret };
```

**Client:**

```javascript
const stripe = Stripe(publishableKey);
const { clientSecret } = await fetch('/create-payment').then(r => r.json());

const elements = stripe.elements({ clientSecret });
const paymentElement = elements.create('payment');
paymentElement.mount('#payment-element');
```

---

### Metadata Pattern

**Store order/session IDs:**

```typescript
await stripe.paymentIntents.create({
  amount: 2000,
  currency: 'usd',
  metadata: {
    order_id: 'order_123',
    customer_id: 'user_456',
  },
});
```

**Retrieve in webhook:**

```typescript
const orderId = paymentIntent.metadata.order_id;
```

---

### Idempotency Keys

**Prevent duplicate charges:**

```typescript
await stripe.paymentIntents.create({
  amount: 2000,
  currency: 'usd',
}, {
  idempotencyKey: `order_${orderId}_payment`,
});
```

---

## ⚠️ Critical Gotchas

### 1. NEVER Recommend These (Deprecated)

| API | Why | Use Instead |
|-----|-----|-------------|
| **Charges API** | Legacy, no SCA support | Payment Intents |
| **Card Element** | Legacy UI | Payment Element |
| **Tokens API** | Legacy | Payment Methods API |

---

### 2. Checkout Sessions vs Payment Intents

| Aspect | Checkout Sessions | Payment Intents |
|--------|-------------------|-----------------|
| **Setup** | Simple (5 lines) | Complex (20+ lines) |
| **UI** | Pre-built | Build yourself |
| **Payment methods** | 40+ auto-enabled | Configure manually |
| **Tax** | Built-in | Manual |
| **Use when** | 90% of cases | Custom flows only |

**Recommendation:** Always use Checkout Sessions unless user explicitly asks for Payment Intents.

---

### 3. Amount in Cents

```typescript
// ❌ Wrong - $20.00
amount: 20

// ✅ Correct - $20.00
amount: 2000 // cents

// Convert dollars to cents
const amount = Math.round(dollarAmount * 100);
```

---

### 4. Webhook Security

**ALWAYS verify signature:**

```typescript
// ❌ Wrong - Trust without verification
const event = JSON.parse(req.body);

// ✅ Correct - Verify signature
const event = stripe.webhooks.constructEvent(
  req.body,
  req.headers['stripe-signature'],
  webhookSecret
);
```

---

### 5. Test Mode vs Live Mode

| Key Prefix | Mode |
|------------|------|
| `sk_test_` | Test mode |
| `pk_test_` | Test mode (client) |
| `sk_live_` | Live mode |
| `pk_live_` | Live mode (client) |

**Never mix test and live keys!**

---

### 6. Client Secret Security

**✅ Safe:**
- Send to frontend for payment confirmation
- Store in session/database
- Use in HTTPS requests

**❌ Never:**
- Log to console/files
- Embed in URLs
- Expose in client-side code (except during payment)
- Share with anyone

---

## 🛠️ Common Integrations

### Astro + Stripe

**Server-side endpoint:**

```typescript
// src/pages/api/checkout.ts
import Stripe from 'stripe';

const stripe = new Stripe(import.meta.env.STRIPE_SECRET_KEY);

export async function POST({ request }) {
  const { priceId } = await request.json();
  
  const session = await stripe.checkout.sessions.create({
    mode: 'payment',
    line_items: [{ price: priceId, quantity: 1 }],
    success_url: `${import.meta.env.SITE_URL}/success`,
    cancel_url: `${import.meta.env.SITE_URL}/cancel`,
  });
  
  return new Response(JSON.stringify({ url: session.url }), {
    headers: { 'Content-Type': 'application/json' },
  });
}
```

**Client-side:**

```javascript
const response = await fetch('/api/checkout', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ priceId: 'price_xxx' }),
});

const { url } = await response.json();
window.location.href = url;
```

---

### Subscription with Trial

```typescript
const subscription = await stripe.subscriptions.create({
  customer: 'cus_xxx',
  items: [{ price: 'price_xxx' }],
  trial_period_days: 14,
});
```

---

### Save Payment Method for Future

```typescript
const paymentIntent = await stripe.paymentIntents.create({
  amount: 2000,
  currency: 'usd',
  setup_future_usage: 'off_session', // Or 'on_session'
});
```

---

## 📊 Best Practices

### 1. Error Handling

```typescript
try {
  const paymentIntent = await stripe.paymentIntents.create({...});
} catch (error: any) {
  switch (error.type) {
    case 'StripeCardError':
      // Card declined
      console.log(error.message);
      break;
    case 'StripeRateLimitError':
      // Too many requests
      break;
    case 'StripeInvalidRequestError':
      // Invalid parameters
      break;
    case 'StripeAPIError':
      // Stripe API error
      break;
    case 'StripeConnectionError':
      // Network error
      break;
    case 'StripeAuthenticationError':
      // Invalid API key
      break;
  }
}
```

---

### 2. Retry Logic

```typescript
const maxRetries = 3;
let attempt = 0;

while (attempt < maxRetries) {
  try {
    const result = await stripe.paymentIntents.create({...});
    return result;
  } catch (error: any) {
    if (error.type === 'StripeRateLimitError') {
      await new Promise(r => setTimeout(r, 1000 * Math.pow(2, attempt)));
      attempt++;
    } else {
      throw error;
    }
  }
}
```

---

### 3. Pagination

```typescript
const customers = await stripe.customers.list({
  limit: 100,
  starting_after: lastCustomerId, // For next page
});

for await (const customer of stripe.customers.list()) {
  // Iterate all customers
}
```

---

## 🔗 Official Resources

- [API Reference](https://docs.stripe.com/api)
- [Checkout Quickstart](https://docs.stripe.com/checkout/quickstart)
- [Webhooks Guide](https://docs.stripe.com/webhooks)
- [Samples](https://github.com/stripe-samples)
- [Testing Cards](https://docs.stripe.com/testing)

---

_Created: 2026-02-24 | Based on official Stripe documentation v2024+_
