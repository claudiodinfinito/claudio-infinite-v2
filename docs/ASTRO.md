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
13. [Astro DB](#13-astro-db)
14. [Sessions](#14-sessions)
15. [Authentication](#15-authentication)
16. [State Management](#16-state-management)
17. [Internationalization (i18n)](#17-internationalization-i18n)
18. [Testing](#18-testing)
19. [Deployment](#19-deployment)
20. [CMS Integrations](#20-cms-integrations)
21. [Backend Services](#21-backend-services)
22. [Configuration Reference](#22-configuration-reference)
23. [Integrations API](#23-integrations-api)
24. [Error Reference](#24-error-reference)
25. [Common Patterns & Recipes](#25-common-patterns--recipes)
26. [Gotchas & Common Mistakes](#26-gotchas--common-mistakes)

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

Content Collections son el sistema type-safe de Astro para organizar contenido (Markdown, MDX, JSON, YAML).

### Configuration File (Astro 5.0+)

```typescript
// src/content.config.ts (nuevo archivo en Astro 5)
import { defineCollection, reference } from 'astro:content';
import { glob, file } from 'astro/loaders';
import { z } from 'astro/zod';

// Define collections
const blog = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/data/blog" }),
  schema: z.object({
    title: z.string(),
    pubDate: z.coerce.date(),
    description: z.string().optional(),
    draft: z.boolean().default(false),
    author: reference('authors'),  // Reference to another collection
    tags: z.array(z.string()).default([]),
  }),
});

const authors = defineCollection({
  loader: glob({ pattern: "**/*.json", base: "./src/data/authors" }),
  schema: z.object({
    name: z.string(),
    email: z.string().email(),
    portfolio: z.string().url().optional(),
  }),
});

export const collections = { blog, authors };
```

### Built-in Loaders

| Loader | Use Case | Example |
|--------|----------|---------|
| `glob()` | Multiple files (MD, MDX, JSON, YAML) | `glob({ pattern: "**/*.md", base: "./src/data" })` |
| `file()` | Single file with multiple entries | `file("src/data/posts.json")` |
| **Custom** | API, CMS, database | `async () => fetch(...).map(item => ({ id, ...item }))` |

### Custom Loader (API/CMS)

```typescript
const countries = defineCollection({
  loader: async () => {
    const response = await fetch("https://restcountries.com/v3.1/all");
    const data = await response.json();
    return data.map((country) => ({
      id: country.cca3,  // Required: unique ID
      ...country,
    }));
  },
  schema: z.object({
    id: z.string(),
    name: z.object({ common: z.string() }),
    region: z.string(),
  }),
});
```

### Query Helpers

```typescript
import { getCollection, getEntry, getEntries, render } from 'astro:content';

// Get all entries
const allPosts = await getCollection('blog');

// Filter entries
const published = await getCollection('blog', ({ data }) => !data.draft);

// Filter by directory
const englishDocs = await getCollection('docs', ({ id }) => id.startsWith('en/'));

// Get single entry
const post = await getEntry('blog', 'my-first-post');

// Render Markdown/MDX to HTML
const { Content, headings } = await render(post);
```

### References Between Collections

```typescript
// Schema with references
const blog = defineCollection({
  schema: z.object({
    title: z.string(),
    author: reference('authors'),            // Single reference
    relatedPosts: z.array(reference('blog')), // Array of references
  }),
});

// Query referenced data
const post = await getEntry('blog', 'welcome');
const author = await getEntry(post.data.author);
const relatedPosts = await getEntries(post.data.relatedPosts);
```

### Static Routes (getStaticPaths)

```astro
---
// src/pages/blog/[id].astro (static build)
import { getCollection, render } from 'astro:content';

export async function getStaticPaths() {
  const posts = await getCollection('blog');
  return posts.map(post => ({
    params: { id: post.id },
    props: { post },
  }));
}

const { post } = Astro.props;
const { Content } = await render(post);
---

<h1>{post.data.title}</h1>
<Content />
```

### SSR Routes

```astro
---
// src/pages/blog/[id].astro (SSR)
import { getEntry, render } from 'astro:content';

export const prerender = false;  // Required in hybrid mode

const { id } = Astro.params;
if (!id) return Astro.redirect('/404');

const post = await getEntry('blog', id);
if (!post) return Astro.redirect('/404');

const { Content } = await render(post);
---

<h1>{post.data.title}</h1>
<Content />
```

### JSON Schema for Editor IntelliSense

Astro auto-generates JSON schemas in `.astro/collections/`:

```json
// VS Code settings.json
{
  "json.schemas": [
    {
      "fileMatch": ["/src/data/authors/**"],
      "url": "./.astro/collections/authors.schema.json"
    }
  ]
}
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

### Rendering Modes

| Mode | Config | Use Case |
|------|--------|----------|
| **Static** | `output: 'static'` (default) | Blogs, docs, marketing sites |
| **SSR** | `output: 'server'` | Dynamic apps, auth, user data |
| **Hybrid** | `output: 'hybrid'` | Mix static + dynamic pages |

### Enable SSR

```javascript
// astro.config.mjs
import vercel from '@astrojs/vercel/serverless';

export default defineConfig({
  output: 'server',
  adapter: vercel(),
});
```

### Available Adapters

| Adapter | Platform | Install |
|---------|----------|---------|
| `@astrojs/vercel/serverless` | Vercel | `npx astro add vercel` |
| `@astrojs/netlify` | Netlify | `npx astro add netlify` |
| `@astrojs/cloudflare` | Cloudflare Workers | `npx astro add cloudflare` |
| `@astrojs/node` | Node.js server | `npx astro add node` |
| `@astrojs/deno` | Deno Deploy | `npx astro add deno` |
| `@astrojs/aws-amplify` | AWS Amplify | Community adapter |

### Hybrid Rendering

Static by default, opt-in SSR per page:

```javascript
// astro.config.mjs
export default defineConfig({
  output: 'hybrid',
  adapter: vercel(),
});
```

```astro
---
// src/pages/dashboard.astro (SSR page)
export const prerender = false;  // Override static default

const user = await getUser(Astro.request);
---

<h1>Welcome, {user.name}</h1>
```

### Request Handling

```astro
---
// Form data
const formData = await Astro.request.formData();
const email = formData.get('email');

// JSON body
const body = await Astro.request.json();

// Headers
const auth = Astro.request.headers.get('Authorization');

// Cookies
const session = Astro.cookies.get('session');

// Redirect
if (!user) {
  return Astro.redirect('/login');
}

// Custom response
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

### Docker Deployment (SSR)

```dockerfile
FROM node:lts
WORKDIR /app
COPY . .
RUN npm ci && npm run build
ENV HOST=0.0.0.0
ENV PORT=4321
EXPOSE 4321
CMD ["node", "./dist/server/entry.mjs"]
```

---

## 13. Astro DB

Astro DB es una base de datos SQL fully-managed integrada en Astro (powered by libSQL/SQLite).

### Installation

```bash
npx astro add db
```

### Define Tables

```typescript
// db/config.ts
import { defineDb, defineTable, column } from 'astro:db';

const Author = defineTable({
  columns: {
    id: column.number({ primaryKey: true }),
    name: column.text(),
    email: column.text({ unique: true }),
    avatar: column.text().optional(),
    createdAt: column.date({ default: new Date() }),
  }
});

const Comment = defineTable({
  columns: {
    id: column.number({ primaryKey: true }),
    authorId: column.number({ references: () => Author.columns.id }),
    postId: column.text(),
    body: column.text(),
    createdAt: column.date({ default: new Date() }),
  }
});

export default defineDb({ tables: { Author, Comment } });
```

### Column Types

| Type | Use Case |
|------|----------|
| `column.text()` | Strings |
| `column.number()` | Integers |
| `column.boolean()` | true/false |
| `column.date()` | Date objects |
| `column.json()` | Untyped JSON |

### Seed Development Data

```typescript
// db/seed.ts
import { db, Author, Comment } from 'astro:db';

export default async function() {
  await db.insert(Author).values([
    { id: 1, name: "Kasim", email: "kasim@example.com" },
    { id: 2, name: "Mina", email: "mina@example.com" },
  ]);

  await db.insert(Comment).values([
    { authorId: 1, postId: 'welcome', body: 'Great post!' },
    { authorId: 2, postId: 'welcome', body: 'Thanks for sharing' },
  ]);
}
```

### Queries with Drizzle ORM

```typescript
import { db, Comment, Author, eq, like, and, or } from 'astro:db';

// SELECT all
const comments = await db.select().from(Comment);

// SELECT with WHERE
const userComments = await db.select()
  .from(Comment)
  .where(eq(Comment.authorId, 1));

// SELECT with LIKE
const searchResults = await db.select()
  .from(Comment)
  .where(like(Comment.body, '%Astro%'));

// SELECT with JOIN
const commentsWithAuthors = await db.select()
  .from(Comment)
  .innerJoin(Author, eq(Comment.authorId, Author.id));

// INSERT
await db.insert(Comment).values({
  authorId: 1,
  postId: 'new-post',
  body: 'New comment'
});

// UPDATE
await db.update(Comment)
  .set({ body: 'Updated comment' })
  .where(eq(Comment.id, 1));

// DELETE
await db.delete(Comment).where(eq(Comment.id, 1));

// BATCH (single network request)
await db.batch([
  db.insert(Comment).values({ authorId: 1, postId: '1', body: 'A' }),
  db.insert(Comment).values({ authorId: 2, postId: '1', body: 'B' }),
]);
```

### Connect to Production (Turso)

```bash
# Environment variables
ASTRO_DB_REMOTE_URL=libsql://your-db.turso.io
ASTRO_DB_APP_TOKEN=eyJhbGciOiJF...

# Push schema to production
astro db push --remote

# Run with remote DB
astro dev --remote
astro build --remote
```

### Use in Pages

```astro
---
// src/pages/blog/[slug].astro
import { db, Comment, eq } from 'astro:db';
import { getEntry, render } from 'astro:content';

export const prerender = false;

const { slug } = Astro.params;
const post = await getEntry('blog', slug);
const comments = await db.select()
  .from(Comment)
  .where(eq(Comment.postId, slug));

const { Content } = await render(post);
---

<h1>{post.data.title}</h1>
<Content />

<h2>Comments ({comments.length})</h2>
{comments.map(c => (
  <article>
    <p>{c.body}</p>
    <small>{c.createdAt.toLocaleDateString()}</small>
  </article>
))}
```

---

## 15. Sessions

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

## 16. Authentication

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

## 17. State Management

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

## 18. Internationalization (i18n)

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

## 19. Testing

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

## 20. Deployment

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

## 21. CMS Integrations

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

## 22. Backend Services

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

## 23. Configuration Reference

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

## 24. Integrations API

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

## 25. Error Reference

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

## 26. Common Patterns & Recipes

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

## 27. Gotchas & Common Mistakes

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

---

## ⚠️ CRITICAL GOTCHA #9: NO Hot-Edit in Production

### The Mistake

Attempting to edit `src/*.astro` files expecting changes to reflect in running server.

### Why It Fails

Astro is **compiled, not interpreted**. The server reads from `dist/`, not `src/`.

```
src/*.astro  →  BUILD  →  dist/  →  SERVER
   ↓              ↓         ↓          ↓
 [edit here]  [compiles] [generated] [runs from here]
```

### The Correct Flow

```bash
# 1. Edit source files
vim src/pages/index.astro

# 2. Build
cd /root/projects/claudio-infinite
npm run build

# 3. Restart server
lsof -ti:4321 | xargs kill -9
HOST=0.0.0.0 PORT=4321 node ./dist/server/entry.mjs
```

### The Rule

> **"Astro is like compiling C: edit → compile → run"**

| ❌ Mal | ✅ Bien |
|--------|---------|
| Edit + esperar cambio | Edit → Build → Restart |
| Modificar `dist/` directo | Modificar `src/` solo |
| Skip build | Siempre build después de cambios |

---

_Lesson learned: 2026-02-25 - Documented after race condition error_
_Last updated: 2026-02-25_
