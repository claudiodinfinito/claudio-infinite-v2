---
name: astro-landing-generator
description: Generate professional landing pages with Astro 5. Use when creating new landing pages, marketing sites, or converting designs to Astro components. Supports hero sections, features, testimonials, pricing, FAQ, and CTA sections with dark theme and responsive design.
---

# Astro Landing Page Generator

Generate production-ready landing pages with Astro 5 following best practices.

## Quick Start

1. **Copy template**:
```bash
cp assets/template/landing.astro src/pages/[page-name].astro
```

2. **Customize sections** (see template comments)
3. **Run dev server**: `npm run dev`

## Template Structure

The template includes 9 sections:

1. **Hero** - Headline, subtitle, CTA buttons, trust badges
2. **Logos** - Trust/company logos
3. **Features** - 3-column grid with icons
4. **How It Works** - 3-step process
5. **Testimonials** - Customer quotes
6. **Pricing** - 3-tier pricing table
7. **FAQ** - Expandable questions
8. **CTA** - Final call-to-action
9. **Footer** - Links and copyright

## Customization Guide

### Hero Section
Replace:
- Badge text
- Headline (H1)
- Subtitle paragraph
- CTA button text/href
- Trust badges

### Features Section
Update each feature card:
- Icon emoji
- Title
- Description

### Pricing Section
Modify pricing tiers:
- Plan names
- Prices
- Feature lists
- "Popular" badge position

### Colors (CSS Variables)
The template uses a dark theme with:
- Primary: `#00d4ff` (cyan)
- Secondary: `#7b2cbf` (purple)
- Background: `#0a0a0f` to `#1a1a2e`

## Build Commands

```bash
npm run dev      # Development
npm run build    # Production
npm run start    # Production server
```

## Requirements

- Astro 5+
- Node adapter (standalone mode)
- No external dependencies (CSS-only)

## Output

- Responsive (mobile-first)
- Dark theme
- No JavaScript required (CSS-only interactions)
- Accessible (semantic HTML)
