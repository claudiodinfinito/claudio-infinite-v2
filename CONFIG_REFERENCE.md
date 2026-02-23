# CONFIG_REFERENCE.md - OpenClaw JSON Configuration Quick Reference

_Derived from official docs at `/usr/lib/node_modules/openclaw/docs/gateway/configuration-reference.md`_

## 🏗️ Top-Level Structure

```json5
{
  agents: {},      // Agent definitions, defaults, routing
  models: {},      // Providers, model aliases, API keys
  channels: {},    // Messaging channels (telegram, whatsapp, etc.)
  session: {},     // Session management, reset policies
  messages: {},    // Response prefix, ack reactions, TTS
  tools: {},       // Tool profiles, allow/deny, elevated access
  sandbox: {},     // Docker sandbox config
  memory: {},      // Memory backend, QMD, citations
  bindings: [],    // Multi-agent routing
  cron: {},        // Scheduled jobs
  heartbeat: {},   // Periodic heartbeat config
  plugins: {},     // Plugin slots (memory, etc.)
}
```

---

## 🤖 agents

### `agents.defaults` (global defaults)

```json5
agents: {
  defaults: {
    workspace: "~/.openclaw/workspace",
    agentDir: "~/.openclaw/agents/main/agent",
    model: "anthropic/claude-opus-4-6",  // string or { primary, fallbacks }
    identity: {
      name: "Claudio",
      theme: "helpful friend",
      emoji: "🐙",
      avatar: "avatars/claudio.png",  // workspace-relative, http(s), or data:
      ackReaction: "👀",  // defaults to identity.emoji
    },
    sandbox: { mode: "off" },  // "off" | "all" | "tools" | "agent"
    tools: {
      profile: "coding",  // minimal | coding | messaging | full
      allow: ["browser"],
      deny: ["canvas"],
    },
    subagents: { allowAgents: ["*"] },  // ["*"] = any, default: same agent only
    compaction: {
      reserveTokensFloor: 20000,
      memoryFlush: {
        enabled: true,
        softThresholdTokens: 4000,
        systemPrompt: "Session nearing compaction. Store durable memories now.",
        prompt: "Write any lasting notes to memory/YYYY-MM-DD.md; reply with NO_REPLY if nothing to store.",
      },
    },
    memorySearch: {
      provider: "openai",  // openai | gemini | local | voyage
      model: "text-embedding-3-small",
      enabled: true,
    },
  },
}
```

### `agents.list` (per-agent overrides)

```json5
agents: {
  list: [
    {
      id: "main",           // required: stable agent id
      default: true,        // first with true wins
      name: "Main Agent",
      workspace: "~/.openclaw/workspace",
      model: { primary: "claude-opus-4-6", fallbacks: ["claude-sonnet"] },
      identity: { name: "Samantha", emoji: "🦥" },
      sandbox: { mode: "off" },
      subagents: { allowAgents: ["*"] },
      tools: { profile: "coding", deny: ["browser"] },
    },
  ],
}
```

### Multi-Agent Routing (`bindings`)

```json5
bindings: [
  { agentId: "home", match: { channel: "whatsapp", accountId: "personal" } },
  { agentId: "work", match: { channel: "whatsapp", accountId: "biz" } },
],
```

**Match precedence:**
1. `match.peer` (direct/group/channel id)
2. `match.guildId` / `match.teamId`
3. `match.accountId` (exact)
4. `match.accountId: "*"` (channel-wide)
5. Default agent

---

## 🧠 models

```json5
models: {
  providers: {
    openai: {
      apiKey: "sk-...",
      baseUrl: "https://api.openai.com/v1",
    },
    anthropic: {
      apiKey: "sk-ant-...",
    },
    google: {
      apiKey: "AIza...",  // Gemini API key
    },
  },
  aliases: {
    "claude-opus": "anthropic/claude-opus-4-6",
    "glm5": "custom-api-us-west-2-modal-direct/zai-org/GLM-5-FP8",
  },
}
```

**Key resolution order:**
1. `models.providers.<provider>.apiKey`
2. Auth profiles (OAuth)
3. Environment variables (`OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `GEMINI_API_KEY`)

---

## 📱 channels

```json5
channels: {
  telegram: {
    enabled: true,
    botToken: "123456:ABC...",
    responsePrefix: "🦞",  // or "auto" for [{identity.name}]
    ackReaction: "👀",
    pollInterval: 1000,
  },
  whatsapp: {
    enabled: true,
    accountId: "personal",
    // ... other config
  },
}
```

---

## 📋 session

```json5
session: {
  scope: "per-sender",
  dmScope: "main",  // main | per-peer | per-channel-peer | per-account-channel-peer
  identityLinks: {
    alice: ["telegram:123456789", "discord:987654321012345678"],
  },
  reset: {
    mode: "daily",  // daily | idle
    atHour: 4,      // for daily reset
    idleMinutes: 60, // for idle reset
  },
  resetByType: {
    thread: { mode: "daily", atHour: 4 },
    direct: { mode: "idle", idleMinutes: 240 },
    group: { mode: "idle", idleMinutes: 120 },
  },
  resetTriggers: ["/new", "/reset"],
  store: "~/.openclaw/agents/{agentId}/sessions/sessions.json",
  maintenance: {
    mode: "warn",  // warn | enforce
    pruneAfter: "30d",
    maxEntries: 500,
    rotateBytes: "10mb",
  },
  sendPolicy: {
    rules: [{ action: "deny", match: { channel: "discord", chatType: "group" } }],
    default: "allow",
  },
}
```

---

## 💬 messages

```json5
messages: {
  responsePrefix: "🦞",  // or "auto"
  ackReaction: "👀",
  ackReactionScope: "group-mentions",  // group-mentions | group-all | direct | all
  removeAckAfterReply: false,
  queue: {
    mode: "collect",  // steer | followup | collect | queue | interrupt
    debounceMs: 1000,
    cap: 20,
    drop: "summarize",  // old | new | summarize
  },
  inbound: {
    debounceMs: 2000,  // 0 disables
  },
  tts: {
    auto: "always",  // off | always | inbound | tagged
    provider: "elevenlabs",
    voiceId: "...",
  },
}
```

---

## 🔧 tools

### Tool Profiles

| Profile | Includes |
|---------|----------|
| `minimal` | `session_status` only |
| `coding` | `group:fs`, `group:runtime`, `group:sessions`, `group:memory`, `image` |
| `messaging` | `group:messaging`, `sessions_list`, `sessions_history`, `sessions_send`, `session_status` |
| `full` | No restriction |

### Tool Groups

| Group | Tools |
|-------|-------|
| `group:runtime` | `exec`, `process` |
| `group:fs` | `read`, `write`, `edit`, `apply_patch` |
| `group:sessions` | `sessions_list`, `sessions_history`, `sessions_send`, `sessions_spawn`, `session_status` |
| `group:memory` | `memory_search`, `memory_get` |
| `group:web` | `web_search`, `web_fetch` |
| `group:ui` | `browser`, `canvas` |
| `group:automation` | `cron`, `gateway` |
| `group:messaging` | `message` |
| `group:nodes` | `nodes` |
| `group:openclaw` | All built-in tools |

### Config

```json5
tools: {
  profile: "coding",
  allow: ["browser"],
  deny: ["canvas"],
  elevated: {
    enabled: true,
    allowFrom: {
      whatsapp: ["+15555550123"],
      discord: ["steipete"],
    },
  },
  exec: {
    backgroundMs: 10000,
    timeoutSec: 1800,
    cleanupMs: 1800000,
  },
  loopDetection: {
    enabled: false,  // disabled by default
    historySize: 30,
    warningThreshold: 10,
    criticalThreshold: 20,
  },
}
```

---

## 🐳 sandbox

```json5
sandbox: {
  mode: "off",  // off | all | tools | agent
  scope: "agent",  // agent | global
  workspaceAccess: "rw",  // rw | ro | none
  docker: {
    image: "openclaw-sandbox",
    binds: ["~/projects:/workspace/projects:ro"],
    network: "bridge",
  },
}
```

---

## 🧠 memory

```json5
memory: {
  backend: "builtin",  // builtin | qmd
  citations: "auto",  // auto | on | off
  qmd: {
    command: "qmd",
    searchMode: "search",  // search | vsearch | query
    includeDefaultMemory: true,
    update: { interval: "5m", debounceMs: 15000 },
    limits: { maxResults: 6, timeoutMs: 4000 },
    paths: [
      { name: "docs", path: "~/notes", pattern: "**/*.md" }
    ],
  },
}
```

---

## ⏰ cron

```json5
cron: {
  enabled: true,
  maxJobs: 50,
  defaultSessionTarget: "isolated",  // main | isolated
  jobs: [
    {
      id: "morning-brief",
      name: "Morning Brief",
      enabled: true,
      schedule: { kind: "cron", expr: "0 8 * * *", tz: "America/Cancun" },
      payload: { kind: "agentTurn", message: "Summarize today's calendar" },
      delivery: { mode: "announce" },  // none | announce | webhook
    },
  ],
}
```

---

## 💓 heartbeat

```json5
heartbeat: {
  enabled: true,
  interval: "10m",
  prompt: "Read HEARTBEAT.md if it exists...",
  sessionTarget: "main",
  maxDelayMs: 30000,
  runOnStartup: true,
}
```

---

## 🔌 plugins

```json5
plugins: {
  slots: {
    memory: "memory-core",  // or "none" to disable
  },
}
```

---

## 🧹 Cleaning Config Safely

**Before removing anything:**
1. Read `CONFIG_REFERENCE.md` to understand what the field does
2. Check `MEMORY.md` for context on why it was added
3. Search `memory/*.md` for related notes
4. Use `gateway action=config.patch` for partial updates (safer than full apply)

**Safe removals (usually):**
- Unused channel configs
- Old model aliases
- Disabled cron jobs

**Never remove without careful review:**
- `agents.defaults` core fields
- `models.providers` API keys
- Active `bindings`
- Session `store` path

---

_This is a condensed reference. Full docs at `/usr/lib/node_modules/openclaw/docs/gateway/configuration-reference.md`_
