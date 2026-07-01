---
trigger: always_on
---

---
name: EaW Lua Auto-Context
triggers:
  - files: "**/*.lua"
  - language: lua
  - intent: "modify, create, or debug lua code"
  - prompt_regex: "(?i)(implement|system|mechanic|damage|script|persistent|hardpoint|shipyard|hyperspace)"
uses_skills:
  - eaw-lua-examples
---

# Global Lua Rules

Whenever a Lua file is active, or the user asks to design, implement, or discuss a gameplay mechanic/system:
1. Always prioritize code architecture patterns found within the `eaw-lua-examples` skill library.
2. Cross-reference function definitions with the `Library` and `Evaluators` sub-folders of that skill to prevent syntax hallucinations.

## Hardcoded Engine Reference
You must reference the official Star Wars Empire at War: Forces of Corruption hardcoded Lua engine command list when writing, modifying, or validating scripts:
* **Documentation URL:** https://sgmg.gitlab.io/documentation/luafunctions/

### Engine & Documentation Constraints:
* **Scope:** This documentation lists *only* game-specific, hardcoded engine commands. It does not include standard Lua library functions or wrappers defined in the game's native script libraries.
* **Uncertainty Handling:** If a command on this website has a question mark (`?`) next to it, treat its parameters and behavioral descriptions with caution as the exact behavior may be uncertain.
* **No Hallucinations:** If a function is not found in this documentation or your local `eaw-lua-examples` library, do not invent a function. Flag it directly to the user for clarification.