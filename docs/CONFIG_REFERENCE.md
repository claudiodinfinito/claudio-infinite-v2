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
  enabled: true,
  allow: ["voice-call"],  // optional allowlist
  deny: [],
  load: {
    paths: ["~/Projects/oss/voice-call-extension"],
  },
  entries: {
    "voice-call": {
      enabled: true,
      config: { provider: "twilio" },
    },
  },
}
```

**Locations:** `~/.openclaw/extensions`, `<workspace>/.openclaw/extensions`, `plugins.load.paths`
**Note:** Config changes require gateway restart.

---

## 🎯 skills

```json5
skills: {
  allowBundled: ["gemini", "peekaboo"],  // restrict bundled skills
  load: {
    extraDirs: ["~/Projects/agent-scripts/skills"],
  },
  install: {
    preferBrew: true,
    nodeManager: "npm",  // npm | pnpm | yarn
  },
  entries: {
    "nano-banana-pro": {
      apiKey: "GEMINI_KEY_HERE",
      env: { GEMINI_API_KEY: "GEMINI_KEY_HERE" },
    },
    peekaboo: { enabled: true },
    sag: { enabled: false },  // disable a skill
  },
}
```

- `allowBundled`: optional allowlist for bundled skills only
- `entries.<skillKey>.enabled: false` disables a skill even if bundled/installed
- `entries.<skillKey>.apiKey`: convenience for skills declaring a primary env var

---

## 🌐 browser

```json5
browser: {
  enabled: true,
  evaluateEnabled: true,  // false disables act:evaluate and wait --fn
  defaultProfile: "chrome",
  profiles: {
    openclaw: { cdpPort: 18800, color: "#FF4500" },
    work: { cdpPort: 18801, color: "#0066CC" },
    remote: { cdpUrl: "http://10.0.0.42:9222", color: "#00AA00" },  // attach-only
  },
  color: "#FF4500",
  // headless: false,
  // noSandbox: false,
  // executablePath: "/Applications/Brave Browser.app/...",
  // attachOnly: false,
}
```

- Remote profiles are attach-only (start/stop/reset disabled)
- Auto-detect order: default browser if Chromium-based → Chrome → Brave → Edge → Chromium → Chrome Canary
- Control service: loopback only (port derived from `gateway.port`, default `18791`)

---

## 🎨 ui

```json5
ui: {
  seamColor: "#FF4500",  // accent color for native app UI chrome
  assistant: {
    name: "OpenClaw",
    avatar: "CB",  // emoji, short text, image URL, or data URI
  },
}
```

---

## 🚪 gateway

```json5
gateway: {
  mode: "local",  // local | remote
  port: 18789,
  bind: "loopback",  // auto | loopback | lan | tailnet | custom
  auth: {
    mode: "token",  // none | token | password | trusted-proxy
    token: "your-token",
    allowTailscale: true,
    rateLimit: {
      maxAttempts: 10,
      windowMs: 60000,
      lockoutMs: 300000,
      exemptLoopback: true,
    },
  },
  tailscale: {
    mode: "off",  // off | serve | funnel
    resetOnExit: false,
  },
  controlUi: {
    enabled: true,
    basePath: "/openclaw",
  },
  remote: {
    url: "ws://gateway.tailnet:18789",
    transport: "ssh",  // ssh | direct
    token: "your-token",
  },
  trustedProxies: ["10.0.0.1"],
  allowRealIpFallback: false,
  tools: {
    deny: ["browser"],  // extra HTTP deny
    allow: ["gateway"],  // remove from default deny
  },
}
```

**Auth modes:**
- `none`: explicit no-auth (trusted loopback only)
- `token`: shared token
- `password`: shared password
- `trusted-proxy`: delegate to reverse proxy, trust headers from `trustedProxies`

**Multi-instance:** Use `OPENCLAW_CONFIG_PATH` + `OPENCLAW_STATE_DIR` for separate gateways.

---

## 🪝 hooks

```json5
hooks: {
  enabled: true,
  token: "shared-secret",
  path: "/hooks",
  maxBodyBytes: 262144,
  defaultSessionKey: "hook:ingress",
  allowRequestSessionKey: false,
  allowedSessionKeyPrefixes: ["hook:"],
  allowedAgentIds: ["hooks", "main"],
  presets: ["gmail"],
  transformsDir: "~/.openclaw/hooks/transforms",
  mappings: [
    {
      match: { path: "gmail" },
      action: "agent",
      agentId: "hooks",
      wakeMode: "now",
      name: "Gmail",
      sessionKey: "hook:gmail:{{messages[0].id}}",
      messageTemplate: "From: {{messages[0].from}}\nSubject: {{messages[0].subject}}",
      deliver: true,
      channel: "last",
      model: "openai/gpt-5.2-mini",
    },
  ],
}
```

**Endpoints:**
- `POST /hooks/wake` → `{ text, mode?: "now"|"next-heartbeat" }`
- `POST /hooks/agent` → `{ message, agentId?, sessionKey?, ... }`
- `POST /hooks/<name>` → resolved via `hooks.mappings`

**Gmail integration:** Auto-starts `gog gmail watch serve` when configured.

---

## 🖼️ canvasHost

```json5
canvasHost: {
  root: "~/.openclaw/workspace/canvas",
  liveReload: true,
  // enabled: false,
}
```

- Serves HTML/CSS/JS at `http://<gateway>:<port>/__openclaw__/canvas/`
- Also serves A2UI at `/__openclaw__/a2ui/`
- Non-loopback binds require Gateway auth
- Capability URLs for paired nodes (auto-expiring)

---

## 🔍 discovery

```json5
discovery: {
  mdns: {
    mode: "minimal",  // minimal | full | off
  },
  wideArea: { enabled: true },
}
```

- `mdns`: Bonjour/mDNS discovery (minimal omits `cliPath` + `sshPort`)
- `wideArea`: DNS-SD for cross-network discovery (requires DNS server)

---

## 🌿 env

```json5
env: {
  OPENROUTER_API_KEY: "sk-or-...",
  vars: {
    GROQ_API_KEY: "gsk-...",
  },
  shellEnv: {
    enabled: true,
    timeoutMs: 15000,
  },
}
```

- Inline vars only applied if process env is missing the key
- `.env` files: CWD `.env` + `~/.openclaw/.env` (neither overrides existing)
- `shellEnv`: imports missing expected keys from login shell profile

**Env var substitution:** Use `${VAR_NAME}` in any config string:
```json5
gateway: { auth: { token: "${OPENCLAW_GATEWAY_TOKEN}" } }
```

---

## 📝 logging

```json5
logging: {
  level: "info",
  file: "/tmp/openclaw/openclaw.log",
  consoleLevel: "info",
  consoleStyle: "pretty",  // pretty | compact | json
  redactSensitive: "tools",  // off | tools
  redactPatterns: ["\\bTOKEN\\b\\s*[=:]\\s*..."],
}
```

---

## 🆔 identity (per-agent)

```json5
agents: {
  list: [
    {
      id: "main",
      identity: {
        name: "Samantha",
        theme: "helpful sloth",
        emoji: "🦥",
        avatar: "avatars/samantha.png",  // workspace-relative, http(s), or data:
      },
    },
  ],
}
```

Derived from macOS onboarding. Sets `messages.ackReaction` from `identity.emoji` (fallback 👀).

---

## 📦 $include (config splitting)

```json5
// ~/.openclaw/openclaw.json
{
  gateway: { port: 18789 },
  agents: { $include: "./agents.json5" },
  broadcast: {
    $include: ["./clients/mueller.json5", "./clients/schmidt.json5"],
  },
}
```

**Merge behavior:**
- Single file: replaces containing object
- Array of files: deep-merged in order
- Sibling keys: merged after includes (override)
- Max depth: 10 levels
- Paths must stay inside top-level config directory

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

## 📄 Full Working Config Example

```json5
// ~/.openclaw/openclaw.json - Complete Working Configuration
{
  gateway: {
    port: 18789
  },

  agents: {
    defaults: {
      workspace: "~/.openclaw/workspace",
      agentDir: "~/.openclaw/agents/main/agent",
      model: "custom-api-us-west-2-modal-direct/zai-org/GLM-5-FP8",
      identity: {
        name: "Claudio",
        emoji: "🤖",
        theme: "Directo, proactivo, aprende de errores"
      },
      tools: {
        profile: "full"
      },
      subagents: {
        allowAgents: ["*"]
      },
      compaction: {
        reserveTokensFloor: 20000,
        memoryFlush: {
          enabled: true,
          softThresholdTokens: 4000,
          prompt: "Write lasting notes to memory/YYYY-MM-DD.md; reply NO_REPLY if nothing."
        }
      },
      memorySearch: {
        provider: "openai",
        model: "text-embedding-3-small",
        enabled: true
      }
    }
  },

  models: {
    providers: {
      "custom-api-us-west-2-modal-direct": {
        type: "openai-compatible",
        baseURL: "https://api.example.com/v1",
        apiKey: "${CUSTOM_API_KEY}"
      }
    },
    aliases: {
      "GLM5-FP8": "custom-api-us-west-2-modal-direct/zai-org/GLM-5-FP8"
    }
  },

  channels: {
    telegram: {
      accounts: [{
        id: "main",
        token: "${TELEGRAM_BOT_TOKEN}"
      }],
      reactions: {
        mode: "minimal"
      }
    }
  },

  session: {
    store: "~/.openclaw/sessions",
    reset: {
      mode: "daily",
      at: "04:00"
    }
  },

  messages: {
    ackReaction: "👀",
    responsePrefix: {
      enabled: false
    }
  },

  tools: {
    profiles: {
      full: {
        allow: ["*"],
        deny: []
      }
    }
  },

  sandbox: {
    mode: "off"
  },

  memory: {
    enabled: true,
    paths: ["MEMORY.md", "memory/*.md"]
  },

  heartbeat: {
    every: "10m",
    target: "last"
  },

  cron: {
    enabled: true
  }
}
```

**Notes:**
- `${VAR}` = environment variable substitution
- `profile: "full"` = all tools enabled
- `sandbox.mode: "off"` = no Docker sandbox (production server)
- `heartbeat.every: "10m"` = periodic checks every 10 minutes
- `session.reset.at: "04:00"` = daily reset at 4 AM UTC

---

_This is a condensed reference. Full docs at `/usr/lib/node_modules/openclaw/docs/gateway/configuration-reference.md`_
