# MEMORY.md - Long-Term Memory

_Curated knowledge that persists across sessions. Update sparingly with high-value insights._

## 👤 User Profile

**Name:** Gamble
**Timezone:** America/Cancun (EST/EDT, UTC-5/-4) — user is in Cancún, Mexico
**Preferences:**
- Wants proactive tool usage (agents, subagents, cronjobs)
- Values token efficiency
- Interested in orchestration and automation
- Wants me to know my capabilities thoroughly

## 🏠 Environment

**VPS:** racknerd-8bf9cb7 (Ubuntu 22.04.5 LTS)
**Role:** Production server running CapRover + OpenClaw
**Off-Limits:** `/captain/` and CapRover containers

## 🔑 Key Insights

### Architecture Understanding (2026-02-22)
- **Tools** = primitive capabilities (read, exec, browser, etc.)
- **Skills** = domain playbooks (how to use tools for specific tasks)
- **Agents/Subagents** = isolated sessions, can use different models
- **Cron** = scheduled/isolated tasks; **Heartbeat** = conversational periodic checks

### Token Efficiency Strategy
- Created `INDEX.md` as quick reference after context reset
- Reading INDEX.md + daily memory ~1000 tokens vs 5000+ exploring
- Use `memory_search` for semantic search before answering questions

## 📌 Active Projects

### claudio-infinite (Astro 5)
**Path:** `/root/projects/claudio-infinite/`
**URL:** `http://100.87.200.4:4321/`
**Stack:** Astro 5 + Hybrid Rendering + Node adapter
**Features:**
- Home page con CSS nativo (dark mode, animaciones)
- Blog con Content Collections (2 posts en MD)
- Contact form con POST processing + debug data
- Learning section con progress bars

**Commands:**
```bash
cd /root/projects/claudio-infinite
npm run build    # Build con hybrid mode
HOST=0.0.0.0 PORT=4321 node ./dist/server/entry.mjs  # Start server
```

## ⚠️ Lessons Learned

### Google OAuth vs API Keys
- `GOCSPX-...` = OAuth Client Secret (NOT for API calls)
- `AIza...` = Gemini/Google API Key (for API calls)
- User had confusion about this — helped clarify

### Gemini CLI Status
- Installed but not authenticated
- Needs `GEMINI_API_KEY` env var with AIza... key
- User mentioned "vector search" token (GOCSPX-...) — was OAuth secret

## 🔮 Future Considerations

- Consider setting up cron jobs for periodic tasks
- Explore subagent orchestration for complex workflows
- May want to add Gemini API key for additional capabilities

## 📚 Documentation Mastery (2026-02-23)

### Config Architecture Learned
- **openclaw.json** is the single source of truth for all configuration
- Top-level sections: `agents`, `models`, `channels`, `session`, `messages`, `tools`, `sandbox`, `memory`, `bindings`, `cron`, `heartbeat`, `plugins`
- **CONFIG_REFERENCE.md** created as quick reference (9KB) — no need to re-read 73KB docs
- Use `gateway action=config.patch` for partial updates (safer than `config.apply`)
- Env var substitution: `${VAR_NAME}` in any config string

### Memory Search Protocol
- **ALWAYS** use `memory_search` tool (NOT exec/grep) for semantic search
- Searches: MEMORY.md + memory/*.md + session transcripts
- Returns: top snippets with path + line numbers
- Follow with `memory_get` to pull specific lines
- Mandatory before answering questions about: prior work, decisions, dates, people, preferences, todos

### Key Config Fields to Remember
- `agents.defaults.model`: Primary model (currently GLM-5-FP8)
- `agents.defaults.workspace`: Workspace path
- `heartbeat.interval`: Periodic check frequency (currently 30m)
- `gateway.port`: WebSocket/HTTP port (18789)
- `session.reset`: When sessions reset (daily at 4 UTC)

## 🧠 Critical Thinking Rule

**When given rules/workflows, evaluate against the specific environment.**

Example: "Token burn" concern → valid for paid APIs, **invalid for GLM5** (unlimited tokens). Old rules may not apply when environment differs.

**Pattern:** Read → Analyze contradictions → Form position → Act

## 🎯 HEARTBEAT.md Orchestrator Architecture (2026-02-23)

### Key Discovery
> "If HEARTBEAT.md exists but is effectively empty, OpenClaw skips the heartbeat run to save API calls."

### Elegant Pattern
- **Config:** Minimal (`"heartbeat": { "every": "10m", "target": "last" }`)
- **HEARTBEAT.md:** All dynamic behavior (tasks, state, mode)
- **Advantages:** Instant updates (no restart), readable state, versionable

### Autonomous Mode Activation
| Command | Duration | Exit Trigger |
|---------|----------|--------------|
| `activa modo autonomo por [X] minutos` | Limited (X min) | Time expiry OR user message |
| `activa modo autonomo` | Indefinite | User message only |
| **20 min inactividad** | Indefinite | Auto-activation until user input |

**Behavior:**
1. Register state in HEARTBEAT.md
2. Execute tasks sequentially WITHOUT waiting for input
3. **One task at a time** — report progress after each
4. Log in `memory/YYYY-MM-DD.md`
5. Exit on trigger → report summary

**Auto-Activation Architecture (2026-02-23):**
```
HEARTBEAT.md = State Machine
├── Config: threshold (20 min), interval (10 min)
├── State: modo, último_mensaje_usuario, último_message_id
├── Logic: algoritmo de activación automática
└── History: sesiones autónomas previas
```

**Key Insight:** All behavior in HEARTBEAT.md → no code changes needed, transparent state, versionable.

**Default Tasks (ordered):**
- Prioridad 1 — Sistema: git, WORKFLOW_AUTO.md alignment, HEARTBEAT.md update
- Prioridad 2 — Mantenimiento: MEMORY.md updates, old logs cleanup
- Prioridad 3 — Exploración: projects/, external repos
- Prioridad 4 — Proactivo: tasks/todo.md, documentation improvements

---

## 📄 LLM-Optimized Documentation (2026-02-24)

### Discovery
Muchos frameworks ahora ofrecen archivos `.txt` optimizados para LLMs:
- `https://docs.X.com/llms-full.txt` - Documentación completa
- `https://docs.X.com/llms.txt` - Índice con links a archivos modulares

### Why It Matters
| Factor | LLM Files | Web Browsing |
|--------|-----------|--------------|
| Velocidad | ✅ Un download | ❌ Múltiples requests |
| Completitud | ✅ 100% contenido | ❌ Truncado 50KB |
| Tokens | ✅ Solo contenido | ❌ HTML noise |

### Pattern
> **Always check for `llms-full.txt` before web browsing documentation.**
> 
> ```bash
> curl -o docs/llms-full.txt https://docs.X.com/llms-full.txt
> ```

---

_Update this file with significant learnings, decisions, and context worth preserving._
