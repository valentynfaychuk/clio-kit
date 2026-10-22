---
name: mnemosyne
description: Pre-submission review with full conversation context. Use after a task looks done, before reporting completion - the fork sees the original brief and everything that happened, nothing needs restating. Returns READY / GAPS_FOUND / BLOCK with a specific list.
---

Spawn the Agent tool with `subagent_type: "fork"` and exactly this prompt, then relay the verdict and gap list verbatim:

"Read `${CLAUDE_PLUGIN_ROOT}/agents/mnemosyne.md` and apply it as written to the conversation you inherit: take the original brief and the work actually performed from this conversation, inspect the diff and artifacts it names, and return only the verdict (READY / GAPS_FOUND / BLOCK with the specific gap list)."

On GAPS_FOUND, address the gaps then re-invoke; on BLOCK, fix the critical gap first. (Skill-level `context: fork` does not inherit the conversation in this build - the Agent-level fork does, which is why this skill routes through it.)
