---
name: eaw-community-lua
description: Use this skill when writing or debugging Star Wars: Empire at War Lua scripts. It contains a massive archive of community-vetted Lua code for reference.
---

# Empire at War Community Lua Skill

## Instructions
1. When the user asks to write a new script, check the code patterns inside the `./library` folder.
2. Follow the specific object structures, wrapper functions, and memory hooks established by these community scripts.
3. Do not invent standard Lua methods; use the game-engine-specific functions found within this library (e.g., `Find_First_Object`, `Evaluate_In_Lua_Environment`).