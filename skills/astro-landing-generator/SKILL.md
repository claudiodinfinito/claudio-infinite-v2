---
name: astro-landing-generator
description: Generate high-converting landing pages with Astro 5 following CRO best practices. Use when creating landing pages, marketing sites, or product showcases. Template includes hero, features grid, benefits section, and CTA optimized for conversions.
---

# Astro Landing Page Generator with CRO

Generate conversion-optimized landing pages with Astro 5.

## Quick Start

```bash
cp assets/template/landing.astro src/pages/[page-name].astro
npm run dev
```

## Structure (CRO-Optimized)

The template follows a proven conversion structure:

1. **Hero Section**
   - Background image with overlay
   - Clear headline (H1)
   - Supporting subtitle
   - Single primary CTA button

2. **Features Grid**
   - 3-column card layout
   - Image + title + description per card
   - Visual hierarchy

3. **Benefits Section**
   - 3-column feature highlights
   - Icon + text combination

4. **Final CTA**
   - Clear action button
   - Contrasting color

## CRO Best Practices

### Hero Section
- **One CTA** - Don't confuse with multiple buttons
- **Clear value proposition** - What does the user get?
- **Above the fold** - CTA visible without scrolling

### Features Grid
- **Visual hierarchy** - Image → Title → Description
- **Scannable** - Users scan, don't read
- **Benefit-focused** - What the user gets, not features

### Benefits Section
- **3 items max** - Easy to remember
- **Icons help scanning** - Visual anchors
- **Clear language** - No jargon

### CTA
- **Action verb** - "Get", "Start", "Learn"
- **Contrasting color** - Stands out
- **Urgency** - "Now", "Today"

## Customization

1. Replace hero image (line ~50)
2. Update headline and subtitle (lines ~60-70)
3. Modify cards in features grid (lines ~100-150)
4. Change CTA text and link (line ~200)
5. Adjust colors in CSS variables (lines ~10-20)

## Build

```bash
npm run build    # Production build
npm run start    # Production server
```

## Requirements

- Astro 5+
- Node adapter
- No external dependencies (CSS-only)
- Mobile-responsive

## Output

- Semantic HTML (accessible)
- Mobile-first responsive
- CSS-only interactions
- Optimized for conversions
