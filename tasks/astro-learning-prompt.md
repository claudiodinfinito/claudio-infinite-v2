# Astro Deep Dive - Learning Prompt

## 🎯 Goal
Convertirse en experto en Astro mediante exploración sistemática de la documentación oficial.

## 📚 Source
**Primary:** `docs/llms-full.txt` (2.6MB, 78,187 líneas) - Documentación oficial completa

## 🧠 Learning Phases

### Phase 1: Fundamentals (Lines 1-15000)
**Topics:**
- [ ] Project structure & conventions
- [ ] Component syntax (.astro files)
- [ ] Pages & routing fundamentals
- [ ] Layouts & slots
- [ ] Configuration (astro.config.mjs)

**Output:** Update ASTRO.md sections 1-4

---

### Phase 2: Core Concepts (Lines 15000-30000)
**Topics:**
- [ ] Islands Architecture deep dive
- [ ] Client directives (client:load, client:visible, etc.)
- [ ] Server islands & deferred rendering
- [ ] Content Collections
- [ ] Markdown/MDX handling

**Output:** Update ASTRO.md sections 5-7

---

### Phase 3: Data & State (Lines 30000-45000)
**Topics:**
- [ ] Data fetching patterns
- [ ] Astro DB integration
- [ ] Actions (server functions)
- [ ] State management (Nanostores)
- [ ] Authentication patterns

**Output:** Update ASTRO.md sections 8-10

---

### Phase 4: Performance & Optimization (Lines 45000-60000)
**Topics:**
- [ ] Image optimization
- [ ] View Transitions API
- [ ] Streaming & deferred loading
- [ ] Bundle optimization
- [ ] Performance best practices

**Output:** Update ASTRO.md sections 11-13

---

### Phase 5: Deployment & Integrations (Lines 60000-78187)
**Topics:**
- [ ] Adapters & deployment platforms
- [ ] UI framework integrations (React, Vue, Svelte)
- [ ] CMS integrations
- [ ] SSR vs SSG vs Hybrid
- [ ] Middleware & advanced patterns

**Output:** Update ASTRO.md sections 14-18

---

## 📝 Reading Strategy

### Each Session:
1. **Read 2000-4000 lines** from current offset
2. **Extract key concepts** with examples
3. **Update ASTRO.md** with refined content
4. **Commit progress** to git
5. **Update this file** with new offset

### Focus Areas:
- **Code examples** → Extract for reference
- **Best practices** → Document clearly
- **Gotchas** → Add to warnings section
- **API signatures** → Keep for quick reference

---

## 📊 Progress Tracking

| Phase | Lines | Offset Start | Offset End | Status |
|-------|-------|--------------|------------|--------|
| 1. Fundamentals | 15000 | 0 | 15000 | 🔄 30% (4500 read) |
| 2. Core Concepts | 15000 | 15000 | 30000 | ⏳ Pending |
| 3. Data & State | 15000 | 30000 | 45000 | ⏳ Pending |
| 4. Performance | 15000 | 45000 | 60000 | ⏳ Pending |
| 5. Deploy & Integrations | 18187 | 60000 | 78187 | ⏳ Pending |

**Current Offset:** 4500
**Lines Remaining:** 73687
**Est. Sessions:** ~20-25 autonomous heartbeat runs

---

## 🎓 Expertise Checklist

After completing all phases, should be able to:

- [ ] Explain Islands Architecture to a beginner
- [ ] Set up a full Astro project from scratch
- [ ] Implement content collections with validation
- [ ] Integrate any UI framework
- [ ] Optimize for performance
- [ ] Deploy to any platform
- [ ] Debug common issues
- [ ] Write custom integrations

---

## 💡 Autonomous Learning Prompt

When in autonomous mode, execute this learning loop:

```
1. CHECK current offset in this file
2. READ next chunk from docs/llms-full.txt (2000-4000 lines)
3. EXTRACT key concepts + code examples
4. UPDATE ASTRO.md with refined content
5. COMMIT changes with descriptive message
6. UPDATE offset in this file
7. REPORT progress to memory/YYYY-MM-DD.md
```

---

_Use this prompt during autonomous heartbeats to systematically master Astro._
