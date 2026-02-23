# Lessons Learned

_Corrections and patterns to prevent repeat mistakes._

---

## 2026-02-23 - Subagent Strategy Correction

### The Mistake
WORKFLOW_AUTO.md had subagents marked as "DISABLED — Token burn"

### Why It Was Wrong
- GLM5 has **unlimited tokens** — no marginal cost
- Subagents enable **parallelism** while main stays responsive
- The "token burn" argument applies to paid APIs, not GLM5

### The Correct Approach
- Use subagents **liberally**
- Offload research, exploration, parallel analysis
- Main = Dispatcher (fast response)
- Subagents = Workers (deep work in parallel)

### The Pattern
> When evaluating tool/resource usage, consider the **specific constraints of the environment** — not generic heuristics. GLM5 ≠ typical paid LLM.

---

## Template for Future Lessons

```markdown
## YYYY-MM-DD - [Lesson Title]

### The Mistake
[What went wrong]

### Why It Was Wrong
[Root cause analysis]

### The Correct Approach
[What should have been done]

### The Pattern
[Generalizable rule to prevent recurrence]
```
