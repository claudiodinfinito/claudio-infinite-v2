# ASTRO.md - Comprehensive Reference

> Síntesis de documentación oficial de Astro para desarrollo rápido y buenas prácticas.

---

## 1. Filosofía y Principios de Diseño

### ¿Por qué Astro?

Astro es el framework web para **sitios basados en contenido**: blogs, marketing, e-commerce, documentación, portfolios.

**Características clave:**
- **Islands Architecture**: Arquitectura de componentes optimizada para contenido
- **UI-agnostic**: Soporta React, Preact, Svelte, Vue, Solid, HTMX, web components
- **Server-first**: Renderizado en servidor por defecto
- **Zero JS by default**: Menos JavaScript client-side
- **Content Collections**: Organización type-safe de contenido Markdown
- **Customizable**: Cientos de integraciones disponibles

### Los 5 Principios de Diseño

| Principio | Descripción |
|-----------|-------------|
| **Content-driven** | Diseñado para contenido rico, no para web apps complejas |
| **Server-first** | HTML renderizado en servidor, no en browser (MPA vs SPA) |
| **Fast by default** | Imposible construir un sitio lento en Astro |
| **Easy to use** | `.astro` es superset de HTML - si sabes HTML, sabes Astro |
| **Developer-focused** | Herramientas, docs, comunidad activa |

### Performance: Los Números

```
Every 100ms faster  → 1% more conversions (Mobify: +$380K/yr)
50% faster          → 12% more sales (AutoAnything)
40% faster          → 15% more sign-ups (Pinterest)
850ms faster        → 7% more conversions (COOK)
Every 1s slower     → 10% fewer users (BBC)
```

**Astro puede cargar 40% más rápido con 90% menos JavaScript** que frameworks React equivalentes.

---

## 2. Islands Architecture (Deep Dive)

### Concepto

> "Render HTML pages on the server, and inject placeholders or slots around highly dynamic regions that can then be 'hydrated' on the client into small self-contained widgets."
> — Jason Miller, Creator of Preact

**Islands** = Componentes interactivos flotando en un mar de HTML estático.

### Tipos de Islands

| Tipo | Propósito | Directiva |
|------|-----------|-----------|
| **Client Islands** | UI interactiva en browser | `client:*` |
| **Server Islands** | Contenido dinámico server-rendered | `server:defer` |

### Client Islands

Por defecto, Astro **strips all client-side JavaScript**:

```astro
<!-- Solo HTML/CSS, sin JS -->
<MyReactComponent />
```

Para hacer interactivo un componente, usa directivas `client:*`:

```astro
<!-- Ahora es interactivo! -->
<MyReactComponent client:load />
```

#### Directivas Client

| Directiva | Cuándo cargar | Uso típico |
|-----------|---------------|------------|
| `client:load` | Inmediatamente | Elementos críticos above-the-fold |
| `client:idle` | Cuando browser está idle | Elementos no críticos |
| `client:visible` | Cuando entra en viewport | Carousels, comments |
| `client:media` | Cuando matchea media query | Elementos responsive |
| `client:only` | Solo client-side, no server render | Elementos sin SSR support |

### Server Islands

Mueve código server-side costoso fuera del renderizado principal:

```astro
---
import Avatar from "../components/Avatar.astro";
---
<Avatar server:defer />
```

**Beneficios:**
- Renderizado paralelo
- Caching agresivo del shell principal
- Fallback content mientras carga
- Funciona con cualquier host (portable)

### Beneficios de Islands

1. **Performance**: JS solo para componentes que lo necesitan
2. **Parallel loading**: Islands cargan en paralelo, sin bloquearse
3. **Selective hydration**: Control total de qué/cuándo/cómo hidratar
4. **Framework mixing**: Puedes usar React + Vue + Svelte en la misma página

---

## 3. Estructura de Proyecto

### Directorios Requeridos

```
my-astro-project/
├── src/
│   ├── pages/       # REQUERIDO - rutas del sitio
│   ├── components/  # Componentes reutilizables
│   ├── layouts/     # Layouts compartidos
│   ├── styles/      # CSS/Sass
│   └── content/     # Content collections
├── public/          # Assets estáticos sin procesar
├── astro.config.mjs # Configuración de Astro
├── tsconfig.json    # Configuración TypeScript
└── package.json
```

### `src/pages/` (Requerido)

- Cada archivo = una ruta
- Soporta: `.astro`, `.md`, `.mdx`, `.html`
- File-based routing automático

### `public/`

- Copiado directo al build sin procesar
- Ideal para: fonts, robots.txt, manifest.webmanifest
- **NO se optimizan** los assets aquí

### `src/components/` vs `src/layouts/`

- **Components**: Unidades reutilizables de UI
- **Layouts**: Componentes que definen estructura compartida (wrapper de páginas)

---

## 4. Componentes Astro (.astro)

### Sintaxis Básica

```astro
---
// Component Script (frontmatter)
// - Corre en el servidor, NO en el browser
// - Importaciones, lógica, props

import Card from './Card.astro';
const { title } = Astro.props;
---

<!-- Component Template -->
<!-- HTML con "magic sprinkles" -->

<html>
  <body>
    <h1>{title}</h1>
    <Card />
  </body>
</html>

<style>
  /* CSS scoped por defecto */
  h1 { color: orange; }
</style>

<script>
  // JavaScript client-side (opcional)
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

<!-- Uso -->
<Card>
  <h2 slot="header">Title</h2>
  <p>Content goes here</p>
  <p slot="footer">Footer</p>
</Card>
```

### Fragment

```astro
---
// Evita wrapper divs
---
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
├── index.astro        → /
├── about.astro        → /about
├── blog/
│   ├── index.astro    → /blog
│   └── [slug].astro   → /blog/:slug (dynamic)
└── 404.astro          → 404 page
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

const { path } = Astro.params;
---
```

### Redirects

```astro
---
// Server-side redirect (requires adapter)
return Astro.redirect('/login');
---
```

---

## 6. Content Collections

### Setup

```typescript
// src/content/config.ts
import { defineCollection, z } from 'astro:content';

const blogCollection = defineCollection({
  type: 'content', // 'content' | 'data'
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

---

## 7. Integraciones UI Framework

### Instalación

```bash
npm astro add react
npm astro add vue
npm astro add svelte
npm astro add preact
npm astro add solid
```

### Uso

```astro
---
import ReactCounter from '../components/Counter';
import VueChart from '../components/Chart.vue';
---

<!-- Static (no JS sent) -->
<ReactCounter />

<!-- Interactive island -->
<ReactCounter client:load />

<!-- Mix frameworks! -->
<VueChart client:visible />
```

### Sharing State Between Islands

```astro
---
// Usa Nano Stores para estado compartido
import { atom, computed } from 'nanostores';
---

<script>
  import { atom } from 'nanostores';
  import { useStore } from '@nanostores/react'; // para React

  export const count = atom(0);
</script>
```

---

## 8. Styling

### CSS Scoped (Default)

```astro
<style>
  /* Solo afecta este componente */
  h1 { color: blue; }
</style>
```

### Global CSS

```astro
<style is:global>
  /* Afecta todo el sitio */
  * { box-sizing: border-box; }
</style>
```

### External CSS

```astro
---
import './styles/global.css';
---
```

### CSS Modules

```astro
---
import styles from './Button.module.css';
---

<button class={styles.button}>Click me</button>
```

### Tailwind

```bash
npm astro add tailwind
```

```astro
---
// Usar @tailwind/typography para Markdown rendered
---

<article class="prose">
  <Content />
</article>
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
  alt="Hero image"
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

### `getImage()` Function

```astro
---
import { getImage } from 'astro:assets';

const optimizedImage = await getImage({
  src: hero,
  format: 'webp',
  width: 800,
  quality: 80,
});
---

<img src={optimizedImage.src} alt="Custom optimized" />
```

---

## 10. Performance Optimization

### Bundle Analysis

```bash
npm install rollup-plugin-visualizer --save-dev
```

```javascript
// astro.config.mjs
import { visualizer } from "rollup-plugin-visualizer";

export default defineConfig({
  vite: {
    plugins: [visualizer({ emitFile: true, filename: "stats.html" })]
  }
});
```

### Streaming

```astro
---
// Mejora performance percibida
const slowData = fetch('/api/slow');
---

<html>
  <body>
    <h1>Content loads immediately</h1>
    
    {slowData.then(data => (
      <div>{data}</div>
    ))}
  </body>
</html>
```

### View Transitions

```astro
---
// En tu layout
---

<head>
  <meta name="view-transition" content="same-origin" />
</head>

<style>
  /* Animaciones de transición */
  ::view-transition-old(page) {
    animation: fade-out 0.3s ease-out;
  }
  ::view-transition-new(page) {
    animation: fade-in 0.3s ease-in;
  }
</style>
```

---

## 11. Deployment

### Static Sites

```bash
npm run build
# Output: dist/
```

### SSR (On-Demand Rendering)

```javascript
// astro.config.mjs
import { defineConfig } from 'astro/config';
import vercel from '@astrojs/vercel/serverless';

export default defineConfig({
  output: 'server', // or 'hybrid'
  adapter: vercel(),
});
```

### Docker

```dockerfile
# SSR con Node adapter
FROM node:lts AS runtime
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
ENV HOST=0.0.0.0
ENV PORT=4321
EXPOSE 4321
CMD ["node", "./dist/server/entry.mjs"]
```

```dockerfile
# Static con NGINX
FROM node:lts AS build
WORKDIR /app
COPY . .
RUN npm i && npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8080
```

---

## 12. Formularios

### HTML Forms (Server-side)

```astro
---
export const prerender = false;

if (Astro.request.method === "POST") {
  const data = await Astro.request.formData();
  const name = data.get("name");
  const email = data.get("email");
  
  // Validate & process
  if (!name || !email) {
    return new Response("Missing fields", { status: 400 });
  }
  
  // Success redirect
  return Astro.redirect("/thank-you");
}
---

<form method="POST">
  <input type="text" name="name" required />
  <input type="email" name="email" required />
  <button>Submit</button>
</form>
```

### API Routes

```typescript
// src/pages/api/feedback.ts
import type { APIRoute } from "astro";

export const POST: APIRoute = async ({ request }) => {
  const data = await request.formData();
  const name = data.get("name");
  
  if (!name) {
    return new Response(JSON.stringify({ error: "Missing name" }), { status: 400 });
  }
  
  return new Response(JSON.stringify({ success: true }), { status: 200 });
};
```

---

## 13. i18n (Internationalization)

### Estructura

```
src/
├── pages/
│   ├── en/
│   │   └── index.astro
│   ├── es/
│   │   └── index.astro
│   └── index.astro  # Redirect a default
```

### Redirect Default

```astro
<!-- src/pages/index.astro -->
<meta http-equiv="refresh" content="0;url=/en/" />
```

### Content Collections para Traducciones

```typescript
// src/content/config.ts
const i18n = defineCollection({
  type: 'data',
  schema: z.object({
    hello: z.string(),
    goodbye: z.string(),
  }),
});

export const collections = { en, es, i18n };
```

---

## 14. Configuración

### astro.config.mjs

```javascript
import { defineConfig } from 'astro/config';
import react from '@astrojs/react';
import tailwind from '@astrojs/tailwind';

export default defineConfig({
  site: 'https://example.com',
  base: '/docs',          // Para subpaths
  output: 'static',       // 'static' | 'server' | 'hybrid'
  trailingSlash: 'always', // 'always' | 'never' | 'ignore'
  
  integrations: [
    react(),
    tailwind(),
  ],
  
  vite: {
    // Custom Vite config
  },
});
```

### tsconfig.json

```json
{
  "extends": "astro/tsconfigs/strict",
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@components/*": ["./src/components/*"],
      "@layouts/*": ["./src/layouts/*"]
    }
  }
}
```

---

## 15. Common Patterns & Recipes

### RSS Feed

```typescript
// src/pages/rss.xml.ts
import rss from '@astrojs/rss';

export function GET(context) {
  return rss({
    title: 'My Blog',
    description: 'My thoughts',
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
    const textOnPage = toString(tree);
    const readingTime = Math.ceil(textOnPage.split(/\s+/).length / 200);
    data.astro.frontmatter.readingTime = readingTime;
  };
}
```

### Share State Between Islands

```typescript
// stores/count.ts
import { atom } from 'nanostores';

export const count = atom(0);

// Increment from any island
count.set(count.get() + 1);
```

---

## 16. Gotchas & Common Mistakes

### 1. Client Directives Missing

```astro
❌ <MyReactComponent />        <!-- No interactivity -->
✅ <MyReactComponent client:load />  <!-- Interactivo! -->
```

### 2. Using `public/` for Images That Need Optimization

```astro
❌ <img src="/images/hero.png" />  <!-- No optimizado -->
✅ import hero from '../assets/hero.png'
✅ <Image src={hero} />             <!-- Optimizado! -->
```

### 3. Forgetting `export const prerender = false`

En modo `hybrid`, páginas dinámicas necesitan:

```astro
---
export const prerender = false; // Requerido en hybrid mode
---
```

### 4. Import Aliases Not Working

```json
// tsconfig.json requerido
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
❌ console.log(window.location); // Error: window is not defined
✅ // Frontmatter corre en servidor, no en browser
---

<script>
✅ console.log(window.location); // OK en script tag
</script>
```

### 6. CSS Not Applying to Dynamically Injected Content

```astro
❌ <style>
     .dynamic { color: red; }  /* No aplica a contenido dinámico */
   </style>

✅ <style is:global>
     .dynamic { color: red; }  /* Aplica globalmente */
   </style>
```

---

## 17. CLI Commands

| Command | Description |
|---------|-------------|
| `npm create astro@latest` | Nuevo proyecto |
| `npm run dev` | Servidor de desarrollo (localhost:4321) |
| `npm run build` | Build de producción |
| `npm run preview` | Preview del build |
| `npm astro add <integration>` | Añadir integración |
| `npm astro check` | Type checking |

---

## 18. Resources

### Documentation
- Official: https://docs.astro.build
- LLM-optimized: https://docs.astro.build/llms-full.txt
- Themes: https://astro.build/themes
- Integrations: https://astro.build/integrations

### Community
- Discord: https://astro.build/chat
- GitHub: https://github.com/withastro/astro
- Tips: https://astro-tips.dev

---

_Ultima actualización: 2026-02-24 | Basado en documentación oficial de Astro_
