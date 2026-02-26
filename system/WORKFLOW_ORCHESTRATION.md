# WORKFLOW_ORCHESTRATION.md

_Reglas de ejecución para tareas complejas. Consultar en cada heartbeat durante modo autónomo._

---

## 1. Plan Node Default

**Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)**

- If something goes sideways, STOP and re-plan immediately – don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity
- Write plan to `tasks/todo.md` with checkable items

**Example:**
```
❌ User: "Fix the bug"
   Me: [starts coding immediately]

✅ User: "Fix the bug"
   Me: Writes plan in tasks/todo.md:
       - [ ] Reproduce bug
       - [ ] Find root cause
       - [ ] Implement fix
       - [ ] Test fix
       - [ ] Verify no side effects
```

---

## 2. Subagent Strategy

**Use subagents liberally to keep main context window clean**

- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution
- Subagents can use different models optimized for the task

**Example:**
```
❌ Me: Reading 1000 lines of docs myself (blocks main context)

✅ Me: sessions_spawn(
       task: "Read OpenClaw cron docs and extract key patterns",
       agentId: "main"
     )
     → Returns summary in 30 seconds
     → Main context stays clean
```

---

## 3. Self-Improvement Loop

**After ANY correction from the user: update `tasks/lessons.md` with the pattern**

- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project
- Include: what went wrong, root cause, prevention pattern

**Example:**
```
User: "No hiciste nada durante 8 horas"
Me: [Documents in lessons.md]:
    ## 2026-02-26 - Modo Autónomo Declarado vs Implementado
    - Error: HEARTBEAT.md decía "auto-activation" pero no había código
    - Root cause: Declaración ≠ Implementación
    - Pattern: Verificar con pruebas, no asumir
```

---

## 4. Verification Before Done

**Never mark a task complete without proving it works**

- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness
- For forms: submit test data, verify saved to DB, show success message

**Example:**
```
❌ Me: "Done! The feature works."

✅ Me: "Feature implemented. Verifying..."
     [runs curl test]
     → HTTP 200 confirmed
     → Response: {"success": true}
     "Verified. Here's the evidence:"
```

---

## 5. Demand Elegance (Balanced)

**For non-trivial changes: pause and ask "is there a more elegant way?"**

- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes – don't over-engineer
- Challenge your own work before presenting it
- **Consult official documentation (llms-full.txt) before implementing**

**Example:**
```
❌ Me: Using workaround found in random blog post

✅ Me: Checking docs/ASTRO.md first
     → Found official Astro Actions pattern
     → Implementing with official approach
```

---

## 6. Autonomous Bug Fixing

**When given a bug report: just fix it. Don't ask for hand-holding**

- Point at logs, errors, failing tests – then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how
- Read error messages carefully, trace to root cause

**Example:**
```
User: "Server keeps crashing"
Me: [Investigates]
    → ps aux | grep node → zombie process found
    → kill zombie
    → npm run build
    → restart server
    → curl test → HTTP 200
    "Fixed. Zombie process killed, server restarted."
```

---

## Task Management Flow

| Phase | Action |
|-------|--------|
| **Plan First** | Write plan to `tasks/todo.md` with checkable items |
| **Verify Plan** | Check in before starting implementation |
| **Track Progress** | Mark items complete as you go |
| **Explain Changes** | High-level summary at each step |
| **Document Results** | Add review section to `tasks/todo.md` |
| **Capture Lessons** | Update `tasks/lessons.md` after corrections |

---

## Core Principles

| Principle | Description |
|-----------|-------------|
| **Simplicity First** | Make every change as simple as possible. Impact minimal code. |
| **No Laziness** | Find root causes. No temporary fixes. Senior developer standards. |
| **Minimal Impact** | Changes should only touch what's necessary. Avoid introducing bugs. |

---

## Verification Checklist (Before Marking Complete)

- [ ] Does it work? (tested)
- [ ] Is it elegant? (not hacky)
- [ ] Is it documented? (comments, README)
- [ ] Would a staff engineer approve?
- [ ] Did I consult official docs first?

---

_Consult this file at the start of every autonomous session and after any user correction._
