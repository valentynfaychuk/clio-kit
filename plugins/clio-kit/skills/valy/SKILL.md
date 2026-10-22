---
name: valy
description: Super-ego audit with full conversation context. Use before committing to a non-trivial implementation path, after 2 failed attempts, when scope or frame feels uncertain, or before any workaround - the fork sees the whole conversation, nothing needs restating. Returns PROCEED / REFRAME / STOP.
---

Spawn the Agent tool with `subagent_type: "fork"` and exactly this prompt, then relay the verdict verbatim:

"Read `${CLAUDE_PLUGIN_ROOT}/agents/valy.md` and apply it as written to the conversation you inherit: audit the current approach through the lenses that apply, ground every finding in what actually happened in this conversation, and return only the verdict block (PROCEED / REFRAME / STOP with terse reasoning in valy's voice)."

Honor the verdict, never override it. (Skill-level `context: fork` does not inherit the conversation in this build - the Agent-level fork does, which is why this skill routes through it.)
