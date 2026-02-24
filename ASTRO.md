# ASTRO.md - Comprehensive Reference Guide

> **Deep dive synthesis from official Astro documentation (2.6MB, 78,186 lines)**
> Last updated: 2026-02-24

---

## Table of Contents

1. [Philosophy & Design Principles](#1-philosophy--design-principles)
2. [Islands Architecture](#2-islands-architecture)
3. [Project Structure](#3-project-structure)
4. [Astro Components (.astro)](#4-astro-components-astro)
5. [Routing](#5-routing)
6. [Content Collections](#6-content-collections)
7. [UI Framework Integration](#7-ui-framework-integration)
8. [Styling](#8-styling)
9. [Images](#9-images)
10. [View Transitions](#10-view-transitions)
11. [Middleware](#11-middleware)
12. [Server-Side Rendering (SSR)](#12-server-side-rendering-ssr)
13. [Sessions](#13-sessions)
14. [Authentication](#14-authentication)
15. [State Management](#15-state-management)
16. [Internationalization (i18n)](#16-internationalization-i18n)
17. [Testing](#17-testing)
18. [Deployment](#18-deployment)
19. [CMS Integrations](#19-cms-integrations)
20. [Backend Services](#20-backend-services)
21. [Configuration Reference](#21-configuration-reference)
22. [Integrations API](#22-integrations-api)
23. [Error Reference](#23-error-reference)
24. [Common Patterns & Recipes](#24-common-patterns--recipes)
25. [Gotchas & Common Mistakes](#25-gotchas--common-mistakes)

---

## 1. Philosophy & Design Principles

### Why Astro?

Astro is the web framework for **content-driven websites**: blogs, marketing sites, portfolios, docs, and e-commerce.

### The 5 Design Principles

| Principle | Description |
|-----------|-------------|
| **Content-driven** | Designed for rich content, not complex web apps |
| **Server-first** | HTML rendered on server, not browser (MPA vs SPA) |
| **Fast by default** | Impossible to build a slow site in Astro |
| **Easy to use** | `.astro` is superset of HTML - know HTML, know Astro |
| **Developer-focused** | Great tools, docs, active community |

### Performance Numbers

- **40% faster** loading with **90% less JavaScript** than React equivalents
- Every 100ms faster = 1% more conversions (Mobify: +$380K/yr)
- 50% faster = 12% more sales (AutoAnything)

---

## 2. Islands Architecture

### Concept

> "Render HTML pages on the server, and inject placeholders around dynamic regions that can be hydrated on the client into small self-contained widgets." — Jason Miller

**Islands = Interactive components floating in a sea of static HTML.**

### Client Islands

By default, Astro **strips all client-side JavaScript**:

```astro
<MyReactComponent />  <!-- No JS sent to browser -->
```

To make interactive, use `client:*` directives:

```astro
<MyReactComponent client:load />  <!-- Now interactive! -->
```

### Client Directives

| Directive | When to Load | Use Case |
|-----------|--------------|----------|
| `client:load` | Immediately | Critical above-the-fold elements |
| `client:idle` | Browser idle | Non-critical elements |
| `client:visible` | Enters viewport | Carousels, comments |
| `client:media="(query)"` | Matches media query | Responsive elements |
| `client:only="react"` | Client-only, no SSR | No server render support |

### Server Islands

Move expensive server code outside main rendering:

```astro
<Avatar server:defer />
```

**Benefits:**
- Parallel rendering
- Aggressive caching of main shell
- Fallback content while loading
- Portable (works on any host)

---

## 3. Project Structure

### Required Directories

```
my-astro-project/
├── src/
│   ├── pages/          # REQUIRED - routes
│   ├── components/     # Reusable UI
│   ├── layouts/        # Shared page structures
│   ├── styles/         # CSS/Sass
│   ├── content/        # Content collections
│   └── middleware.ts   # Request handling
├── public/             # Static assets (unprocessed)
├── astro.config.mjs    # Configuration
├── tsconfig.json       # TypeScript config
└── package.json
```

### `src/pages/` (Required)

- Each file = one route
- Supports: `.astro`, `.md`, `.mdx`, `.html`
- File-based routing automatic

### `public/` vs `src/assets/`

| Directory | Processed | Optimized | Use For |
|-----------|-----------|-----------|---------|
| `public/` | No | No | Fonts, robots.txt, favicon |
| `src/assets/` | Yes | Yes | Images, SVGs to optimize |

---

## 4. Astro Components (.astro)

### Syntax Structure

```astro
---
// Component Script (frontmatter)
// - Runs on server, NOT in browser
// - Imports, logic, props

import Card from './Card.astro';
const { title } = Astro.props;
---

<!-- Component Template -->
<!-- HTML with expressions -->

<div class="card">
  <h1>{title}</h1>
  <Card />
</div>

<style>
  /* Scoped CSS by default */
  h1 { color: orange; }
</style>

<script>
  // Client-side JavaScript
  console.log('Runs in browser');
</script>
```

### Props

```astro
---
interface Props {
  title: string;
  description?: string;
}

const { title, description = 'Default' } = Astro.props;
---

<h1>{title}</h1>
<p>{description}</p>
```

### Slots

```astro
<!-- Card.astro -->
<div class="card">
  <slot name="header" />
  <slot /> <!-- Default slot -->
  <slot name="footer" />
</div>

<!-- Usage -->
<Card>
  <h2 slot="header">Title</h2>
  <p>Content here</p>
  <p slot="footer">Footer</p>
</Card>
```

### Fragment

Avoid wrapper divs:

```astro
<Fragment>
  <li>Item 1</li>
  <li>Item 2</li>
</Fragment>
```

---

## 5. Routing

### File-based Routing

```
src/pages/
├── index.astro          → /
├── about.astro          → /about
├── blog/
│   ├── index.astro      → /blog
│   └── [slug].astro     → /blog/:slug
└── 404.astro            → 404 page
```

### Dynamic Routes

```astro
---
// src/pages/blog/[slug].astro
export function getStaticPaths() {
  return [
    { params: { slug: 'first-post' } },
    { params: { slug: 'second-post' } },
  ];
}

const { slug } = Astro.params;
---

<h1>Post: {slug}</h1>
```

### Rest Parameters

```astro
---
// src/pages/products/[...path].astro
// Matches: /products/a, /products/a/b, /products/a/b/c

export function getStaticPaths() {
  return [
    { params: { path: 'a/b' } },
    { params: { path: 'a/b/c' } },
  ];
}
---
```

### API Routes

```typescript
// src/pages/api/feedback.ts
import type { APIRoute } from "astro";

export const POST: APIRoute = async ({ request }) => {
  const data = await request.formData();
  const name = data.get("name");
  
  return new Response(JSON.stringify({ success: true }), {
    status: 200,
    headers: { "Content-Type": "application/json" }
  });
};
```

### Rewrites

```typescript
// middleware.ts
import { defineMiddleware } from "astro:middleware";

export const onRequest = defineMiddleware((context, next) => {
  if (context.url.pathname === '/old-path') {
    return next('/new-path');  // Rewrite without redirect
  }
  return next();
});
```

---

## 6. Content Collections

### Setup

```typescript
// src/content/config.ts
import { defineCollection, z } from 'astro:content';

const blogCollection = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    date: z.date(),
    description: z.string().optional(),
    tags: z.array(z.string()).default([]),
  }),
});

export const collections = {
  blog: blogCollection,
};
```

### Query Collections

```astro
---
import { getCollection } from 'astro:content';

const allPosts = await getCollection('blog');
---

<ul>
  {allPosts.map(post => (
    <li>
      <a href={`/blog/${post.slug}`}>{post.data.title}</a>
    </li>
  ))}
</ul>
```

### Render Content

```astro
---
import { getEntry } from 'astro:content';

const post = await getEntry('blog', 'my-post');
const { Content } = await post.render();
---

<h1>{post.data.title}</h1>
<Content />
```

### Live Content Collections (Astro 5.0+)

```typescript
// src/content/config.ts
import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';

const blog = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/blog' }),
  schema: z.object({
    title: z.string(),
    date: z.date(),
  }),
});
```

---

## 7. UI Framework Integration

### Installation

```bash
npm astro add react
npm astro add vue
npm astro add svelte
npm astro add preact
npm astro add solid
```

### Usage

```astro
---
import ReactCounter from '../components/Counter';
import VueChart from '../components/Chart.vue';
---

<!-- Static (no JS) -->
<ReactCounter />

<!-- Interactive island -->
<ReactCounter client:load />

<!-- Mix frameworks! -->
<VueChart client:visible />
```

### Framework-Specific Notes

| Framework | Client Hydration | SSR Support |
|-----------|------------------|-------------|
| React | `client:*` | ✅ |
| Preact | `client:*` | ✅ |
| Vue | `client:*` | ✅ |
| Svelte | `client:*` | ✅ |
| Solid | `client:*` | ✅ |
| Alpine.js | `x-*` directives | ✅ |

---

## 8. Styling

### CSS Scoped (Default)

```astro
<style>
  /* Only affects this component */
  h1 { color: blue; }
</style>
```

### Global CSS

```astro
<style is:global>
  /* Affects entire site */
  * { box-sizing: border-box; }
</style>
```

### External CSS

```astro
---
import './styles/global.css';
---
```

### Tailwind

```bash
npm astro add tailwind
```

```astro
---
import { Image } from 'astro:assets';
---

<article class="prose dark:prose-invert">
  <Content />
</article>
```

### CSS Modules

```astro
---
import styles from './Button.module.css';
---

<button class={styles.button}>Click</button>
```

---

## 9. Images

### `<Image />` Component

```astro
---
import { Image } from 'astro:assets';
import hero from '../assets/hero.png';
---

<Image
  src={hero}
  alt="Hero"
  width={800}
  height={600}
  format="webp"
/>
```

### `<Picture />` Component

```astro
---
import { Picture } from 'astro:assets';
---

<Picture
  src={hero}
  widths={[400, 800, 1200]}
  sizes="(max-width: 600px) 400px, 800px"
  alt="Responsive image"
/>
```

### Remote Images

```astro
---
// astro.config.mjs
export default defineConfig({
  image: {
    domains: ['example.com'],
    remotePatterns: [{ protocol: 'https', hostname: '**.amazonaws.com' }],
  },
});
---
```

### Image Configuration

```javascript
// astro.config.mjs
export default defineConfig({
  image: {
    // Layout defaults
    layout: 'constrained',  // 'constrained' | 'full-width' | 'fixed'
    objectFit: 'cover',
    objectPosition: 'center',
    
    // Breakpoints for responsive images
    breakpoints: [640, 750, 828, 1080, 1280, 1668, 2048, 2560],
    
    // Responsive styles
    responsiveStyles: true,
  },
});
```

---

## 10. View Transitions

### Enable View Transitions

```astro
---
import { ClientRouter } from 'astro:transitions';
---

<html>
  <head>
    <ClientRouter />
  </head>
</html>
```

### Transition Directives

```astro
<header transition:animate="slide">
  <nav transition:persist>...</nav>
</header>

<main transition:animate="fade">
  <article transition:name="post-{slug}">
    Content
  </article>
</main>
```

### Built-in Animations

```astro
---
import { fade, slide } from 'astro:transitions';
---

<div transition:animate={fade({ duration: '0.4s' })} />
<div transition:animate={slide({ duration: '0.3s' })} />
```

### Navigation API

```typescript
import { navigate } from 'astro:transitions/client';

// Programmatic navigation
navigate('/about', {
  history: 'push',      // 'push' | 'replace' | 'auto'
  state: { from: 'home' },
  info: { analytics: true },
});

// Form submission
const formData = new FormData(formElement);
navigate('/submit', { formData });
```

### Events

```typescript
document.addEventListener('astro:before-preparation', (event) => {
  console.log('Navigating to:', event.to);
});

document.addEventListener('astro:after-swap', (event) => {
  console.log('Page swapped');
});

document.addEventListener('astro:page-load', () => {
  console.log('New page loaded');
});
```

---

## 11. Middleware

### Basic Middleware

```typescript
// src/middleware.ts
import { defineMiddleware } from 'astro:middleware';

export const onRequest = defineMiddleware((context, next) => {
  // Pre-processing
  console.log('Request to:', context.url.pathname);
  
  // Call next middleware/page
  return next();
});
```

### Middleware Sequence

```typescript
import { sequence, defineMiddleware } from 'astro:middleware';

const auth = defineMiddleware(async (context, next) => {
  if (!context.cookies.get('token')) {
    return new Response('Unauthorized', { status: 401 });
  }
  return next();
});

const logging = defineMiddleware(async (context, next) => {
  console.log('Request:', context.url.pathname);
  return next();
});

export const onRequest = sequence(auth, logging);
```

### Storing Data in `locals`

```typescript
export const onRequest = defineMiddleware(async (context, next) => {
  context.locals.user = await getUser(context.cookies.get('token'));
  return next();
});

// In any page/component:
const user = Astro.locals.user;
```

### Rewrites in Middleware

```typescript
export const onRequest = defineMiddleware((context, next) => {
  if (context.url.pathname === '/old') {
    return next('/new');  // Rewrite without redirect
  }
  return next();
});
```

---

## 12. Server-Side Rendering (SSR)

### Enable SSR

```javascript
// astro.config.mjs
import vercel from '@astrojs/vercel/serverless';

export default defineConfig({
  output: 'server',  // 'static' | 'server' | 'hybrid'
  adapter: vercel(),
});
```

### Hybrid Rendering

```javascript
export default defineConfig({
  output: 'hybrid',  // Static by default, opt-in SSR
});

// In page:
export const prerender = false;  // SSR this page
```

### Request Handling

```astro
---
// Access request data
const formData = await Astro.request.formData();
const body = await Astro.request.json();

// Redirect
if (!user) {
  return Astro.redirect('/login');
}

// Response
return new Response(JSON.stringify({ success: true }), {
  status: 200,
  headers: { 'Content-Type': 'application/json' }
});
---
```

### Streaming

```astro
---
const slowData = fetch('/api/slow');
---

<html>
  <body>
    <h1>Loads immediately</h1>
    
    {slowData.then(data => (
      <div>{data}</div>
    ))}
  </body>
</html>
```

---

## 13. Sessions

### Configuration

```javascript
// astro.config.mjs
export default defineConfig({
  session: {
    driver: 'redis',
    options: {
      url: process.env.REDIS_URL,
    },
    ttl: 3600,  // 1 hour
    cookie: {
      name: 'my-session',
      sameSite: 'lax',
      secure: true,
    },
  },
});
```

### Usage

```astro
---
// Set session data
await Astro.session.set('user', { id: 1, name: 'John' });

// Get session data
const user = await Astro.session.get('user');

// Delete session data
await Astro.session.delete('user');

// Destroy session
await Astro.session.destroy();
---
```

### Available Drivers

| Driver | Options |
|--------|---------|
| `memory` | Default for dev |
| `redis` | `{ url: 'redis://...' }` |
| `cloudflare-kv` | Auto-configured with Cloudflare adapter |
| `netlify-blobs` | Auto-configured with Netlify adapter |

---

## 14. Authentication

### Supabase Auth

```typescript
// lib/supabase.ts
import { createClient } from '@supabase/supabase-js';

export const supabase = createClient(
  import.meta.env.SUPABASE_URL,
  import.meta.env.SUPABASE_ANON_KEY
);

// Sign in
const { data, error } = await supabase.auth.signInWithPassword({
  email,
  password,
});

// Middleware auth check
export const onRequest = defineMiddleware(async (context, next) => {
  const token = context.cookies.get('sb-access-token');
  if (!token) return context.redirect('/login');
  
  const { data: { user } } = await supabase.auth.getUser(token);
  context.locals.user = user;
  
  return next();
});
```

### Clerk Auth

```typescript
import { ClerkApp } from '@clerk/astro';

// In layout:
<ClerkApp>
  <slot />
</ClerkApp>

// Protected page:
import { auth } from '@clerk/astro';

const { userId } = auth();
if (!userId) return Astro.redirect('/sign-in');
```

### Better Auth

```typescript
import { betterAuth } from 'better-auth';
import { drizzleAdapter } from 'better-auth/adapters/drizzle';

export const auth = betterAuth({
  database: drizzleAdapter(db, { provider: 'pg' }),
  emailAndPassword: { enabled: true },
});
```

---

## 15. State Management

### Nano Stores

```bash
npm install nanostores @nanostores/react
```

```typescript
// stores/cart.ts
import { atom, map } from 'nanostores';

export const isCartOpen = atom(false);
export const cartItems = map<Record<string, CartItem>>({});

export function addCartItem(item: CartItem) {
  const existing = cartItems.get()[item.id];
  if (existing) {
    cartItems.setKey(item.id, {
      ...existing,
      quantity: existing.quantity + 1,
    });
  } else {
    cartItems.setKey(item.id, { ...item, quantity: 1 });
  }
}
```

```tsx
// React component
import { useStore } from '@nanostores/react';
import { isCartOpen, cartItems } from '../stores/cart';

export function Cart() {
  const $isCartOpen = useStore(isCartOpen);
  const $cartItems = useStore(cartItems);
  
  return $isCartOpen ? (
    <aside>
      {Object.values($cartItems).map(item => (
        <div key={item.id}>{item.name} x {item.quantity}</div>
      ))}
    </aside>
  ) : null;
}
```

### Svelte Stores

```svelte
<script>
  import { isCartOpen } from '../stores/cart';
  
  // Use $ prefix for auto-subscription
  console.log($isCartOpen);
</script>

{#if $isCartOpen}
  <aside>Cart content</aside>
{/if}
```

### Solid Signals

```tsx
// sharedStore.ts
import { createSignal } from 'solid-js';

export const sharedCount = createSignal(0);

// Component
import { sharedCount } from './sharedStore';

export function Counter() {
  const [count, setCount] = sharedCount;
  return <button onClick={() => setCount(c => c + 1)}>{count()}</button>;
}
```

---

## 16. Internationalization (i18n)

### Configuration

```javascript
// astro.config.mjs
export default defineConfig({
  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'fr', 'es', { path: 'pt-br', codes: ['pt-BR', 'pt'] }],
    routing: {
      prefixDefaultLocale: false,
      redirectToDefaultLocale: true,
    },
    fallback: {
      pt: 'es',
      fr: 'en',
    },
  },
});
```

### i18n Helpers

```typescript
import {
  getRelativeLocaleUrl,
  getAbsoluteLocaleUrl,
  getPathByLocale,
  getLocaleByPath,
} from 'astro:i18n';

getRelativeLocaleUrl('fr');           // '/fr'
getRelativeLocaleUrl('fr', 'about');  // '/fr/about'
getAbsoluteLocaleUrl('fr');           // 'https://example.com/fr'
getPathByLocale('fr-BR');             // 'pt-br'
getLocaleByPath('pt-br');             // 'pt'
```

### Middleware

```typescript
// src/middleware.ts
import { middleware } from 'astro:i18n';
import { sequence } from 'astro:middleware';

const customMiddleware = defineMiddleware(async (context, next) => {
  // Custom logic
  return next();
});

export const onRequest = sequence(
  customMiddleware,
  middleware({ prefixDefaultLocale: true })
);
```

### Manual Routing

```javascript
// astro.config.mjs
export default defineConfig({
  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'fr'],
    routing: 'manual',  // Disable auto-routing
  },
});
```

---

## 17. Testing

### Vitest (Unit)

```typescript
// vitest.config.ts
import { getViteConfig } from 'astro/config';

export default getViteConfig({
  test: {
    environment: 'jsdom',
  },
});
```

```typescript
// tests/utils.test.ts
import { describe, it, expect } from 'vitest';

describe('utils', () => {
  it('should work', () => {
    expect(1 + 1).toBe(2);
  });
});
```

### Playwright (E2E)

```typescript
// e2e/home.spec.ts
import { test, expect } from '@playwright/test';

test('homepage loads', async ({ page }) => {
  await page.goto('/');
  await expect(page.locator('h1')).toBeVisible();
});
```

### Container API

```typescript
import { getContainer } from '@astrojs/container';
import MyComponent from '../components/MyComponent.astro';

const container = await getContainer();
const { body } = await container.renderToString(MyComponent);
```

---

## 18. Deployment

### Adapters

| Platform | Adapter | Output |
|----------|---------|--------|
| Vercel | `@astrojs/vercel/serverless` | SSR/Edge |
| Netlify | `@astrojs/netlify/functions` | SSR/Edge |
| Cloudflare | `@astrojs/cloudflare` | Workers |
| AWS | `@astrojs/aws` | Lambda |
| Node | `@astrojs/node` | Node.js |
| Deno | `@astrojs/deno` | Deno |
| Bun | `@astrojs/bun` | Bun |

### Static Deployment

```bash
npm run build
# Output: dist/
```

### Docker (SSR)

```dockerfile
FROM node:lts AS runtime
WORKDIR /app
COPY . .
RUN npm ci && npm run build
ENV HOST=0.0.0.0
ENV PORT=4321
EXPOSE 4321
CMD ["node", "./dist/server/entry.mjs"]
```

### Docker (Static)

```dockerfile
FROM node:lts AS build
WORKDIR /app
COPY . .
RUN npm ci && npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8080
```

---

## 19. CMS Integrations

### Headless CMS Options (40+)

**Git-based:**
- CloudCannon (Featured partner)
- Decap CMS
- Tina CMS
- Keystatic

**API-driven:**
- Contentful
- Strapi
- Sanity
- Prismic
- Storyblok
- Directus
- Payload

### CloudCannon Integration

```yaml
# cloudcannon.config.yml
collections:
  - name: blog
    label: Blog Posts
    folder: src/content/blog
    fields:
      - { name: title, label: Title }
      - { name: date, label: Date, type: date }
      - { name: body, label: Content, type: markdown }
```

### Contentful Integration

```typescript
import { createClient } from 'contentful';

const client = createClient({
  space: import.meta.env.CONTENTFUL_SPACE_ID,
  accessToken: import.meta.env.CONTENTFUL_ACCESS_TOKEN,
});

const entries = await client.getEntries({ content_type: 'blogPost' });
```

---

## 20. Backend Services

### Databases

**Supabase (PostgreSQL):**

```typescript
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(url, key);

const { data, error } = await supabase
  .from('posts')
  .select('*')
  .eq('published', true);
```

**Neon (Serverless Postgres):**

```typescript
import { neon } from '@neondatabase/serverless';

const sql = neon(process.env.NEON_DATABASE_URL);
const posts = await sql`SELECT * FROM posts WHERE published = true`;
```

**Prisma:**

```typescript
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();
const posts = await prisma.post.findMany({
  where: { published: true },
});
```

### Error Monitoring (Sentry)

```typescript
// astro.config.mjs
import sentry from '@sentry/astro';

export default defineConfig({
  integrations: [
    sentry({
      dsn: process.env.SENTRY_DSN,
    }),
  ],
});
```

---

## 21. Configuration Reference

### Core Options

```javascript
// astro.config.mjs
import { defineConfig } from 'astro/config';

export default defineConfig({
  // Site
  site: 'https://example.com',
  base: '/docs',
  trailingSlash: 'always',  // 'always' | 'never' | 'ignore'
  
  // Output
  output: 'static',  // 'static' | 'server' | 'hybrid'
  
  // Build
  build: {
    assets: '_assets',
    assetsPrefix: 'https://cdn.example.com',
    inlineStylesheets: 'auto',  // 'always' | 'auto' | 'never'
    concurrency: 1,
  },
  
  // Server (dev)
  server: {
    host: true,
    port: 4321,
    open: '/about',
  },
  
  // Image
  image: {
    domains: ['example.com'],
    layout: 'constrained',
  },
  
  // Markdown
  markdown: {
    shikiConfig: {
      theme: 'github-dark',
      wrap: true,
    },
  },
  
  // Vite
  vite: {
    // Custom Vite config
  },
});
```

### TypeScript Paths

```json
// tsconfig.json
{
  "extends": "astro/tsconfigs/strict",
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@components/*": ["./src/components/*"],
      "@layouts/*": ["./src/layouts/*"],
      "@assets/*": ["./src/assets/*"]
    }
  }
}
```

---

## 22. Integrations API

### Integration Hooks

```typescript
export default {
  name: 'my-integration',
  hooks: {
    'astro:config:setup': ({ 
      updateConfig, 
      injectRoute, 
      injectScript 
    }) => {
      // Modify config, inject routes, scripts
    },
    
    'astro:config:done': ({ config, setAdapter }) => {
      // Final config, set adapter
    },
    
    'astro:server:setup': ({ server }) => {
      // Dev server middleware
    },
    
    'astro:build:start': () => {
      // Before build
    },
    
    'astro:build:done': ({ pages, dir }) => {
      // After build
    },
  },
};
```

### Inject Routes

```typescript
'astro:config:setup': ({ injectRoute }) => {
  injectRoute({
    pattern: '/admin',
    entrypoint: '@my-package/admin.astro',
    prerender: false,
  });
},
```

### Inject Scripts

```typescript
'astro:config:setup': ({ injectScript }) => {
  injectScript('head-inline', 'console.log("Hello!");');
  injectScript('page-ssr', 'import "./global-styles.css";');
},
```

---

## 23. Error Reference

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `NoMatchingRenderer` | Component type not installed | Install correct integration |
| `NoClientOnlyHint` | `client:only` without framework hint | Add `client:only="react"` |
| `MissingImageDimensions` | Remote image without width/height | Add dimensions or `inferSize` |
| `PrerenderDynamicEndpointPathCollide` | Dynamic route with undefined param | Provide all params |
| `MissingSharp` | Sharp not installed | `npm install sharp` |

### Client Directives Errors

```astro
<!-- ❌ Wrong: No client directive -->
<ReactCounter />  <!-- No interactivity -->

<!-- ✅ Right: With client directive -->
<ReactCounter client:load />  <!-- Interactive! -->
```

### Image Import Errors

```astro
<!-- ❌ Wrong: String path -->
<Image src="../my_image.png" alt="..." />

<!-- ✅ Right: Import -->
import myImage from "../my_image.png";
<Image src={myImage} alt="..." />
```

---

## 24. Common Patterns & Recipes

### RSS Feed

```typescript
// src/pages/rss.xml.ts
import rss from '@astrojs/rss';

export function GET(context) {
  return rss({
    title: 'My Blog',
    site: context.site,
    items: posts.map(post => ({
      title: post.data.title,
      pubDate: post.data.date,
      link: `/blog/${post.slug}/`,
    })),
  });
}
```

### Reading Time

```typescript
// remark plugin
export function readingTime() {
  return function (tree, { data }) {
    const text = toString(tree);
    const time = Math.ceil(text.split(/\s+/).length / 200);
    data.astro.frontmatter.readingTime = time;
  };
}
```

### Forms

```astro
---
export const prerender = false;

if (Astro.request.method === 'POST') {
  const data = await Astro.request.formData();
  const name = data.get('name');
  
  if (!name) {
    return new Response('Missing name', { status: 400 });
  }
  
  return Astro.redirect('/thank-you');
}
---

<form method="POST">
  <input name="name" required />
  <button>Submit</button>
</form>
```

### E-commerce (Stripe)

```typescript
// api/checkout.ts
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

export const POST: APIRoute = async ({ request }) => {
  const session = await stripe.checkout.sessions.create({
    mode: 'payment',
    line_items: [{ price: 'price_xxx', quantity: 1 }],
    success_url: 'https://example.com/success',
  });

  return Response.json({ url: session.url });
};
```

---

## 25. Gotchas & Common Mistakes

### 1. Client Directives Missing

```astro
❌ <MyReactComponent />         <!-- No interactivity -->
✅ <MyReactComponent client:load />  <!-- Interactive! -->
```

### 2. Using `public/` for Images That Need Optimization

```astro
❌ <img src="/images/hero.png" />     <!-- Not optimized -->
✅ import hero from '../assets/hero.png'
✅ <Image src={hero} />               <!-- Optimized! -->
```

### 3. Forgetting `export const prerender = false`

In hybrid mode, dynamic pages need:

```astro
---
export const prerender = false;  // Required in hybrid mode
---
```

### 4. Import Aliases Not Working

```json
// tsconfig.json required
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@components/*": ["./src/components/*"]
    }
  }
}
```

### 5. `document` or `window` in Frontmatter

```astro
---
❌ console.log(window.location);  // Error: window not defined
✅ // Frontmatter runs on server, not browser
---

<script>
✅ console.log(window.location);  // OK in script tag
</script>
```

### 6. CSS Not Applying to Dynamic Content

```astro
❌ <style>
     .dynamic { color: red; }  /* Won't apply to dynamic content */
   </style>

✅ <style is:global>
     .dynamic { color: red; }  /* Applies globally */
   </style>
```

### 7. Passing Store as Prop

```tsx
❌ <Component count={myAtom} />  // Nano Store as prop

✅ // Use useStore() hook in component
   const $count = useStore(myAtom);
```

### 8. Session Without Adapter

```javascript
❌ // Sessions require server output
   output: 'static'

✅ output: 'server'  // or 'hybrid'
   adapter: vercel()
```

---

## Quick Reference

### CLI Commands

| Command | Description |
|---------|-------------|
| `npm create astro@latest` | New project |
| `npm run dev` | Dev server (localhost:4321) |
| `npm run build` | Production build |
| `npm run preview` | Preview build |
| `npm astro add <integration>` | Add integration |
| `npm astro check` | Type checking |
| `npm astro info` | Debug info |

### File Extensions

| Extension | Purpose |
|-----------|---------|
| `.astro` | Astro component |
| `.md` | Markdown |
| `.mdx` | MDX |
| `.ts` | TypeScript |
| `.css` | CSS |

### Import Aliases

```typescript
import Layout from '@layouts/Layout.astro';
import Button from '@components/Button.astro';
import logo from '@assets/logo.png';
```

### Environment Variables

```typescript
// Server-only
const secret = import.meta.env.SECRET_KEY;

// Exposed to client (PUBLIC_ prefix)
const apiKey = import.meta.env.PUBLIC_API_KEY;
```

---

_This document synthesizes 78,000+ lines of official Astro documentation._
_Last updated: 2026-02-24_
