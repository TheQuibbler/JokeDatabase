# Coding Style & Agent Instructions (Repository-Agnostic)

Purpose
- Define clear rules and conventions that other projects should follow so contributions are consistent, maintainable, and easy for agents to automate.

Principles
- Prioritize readability, simplicity, and safety.
- Prefer explicitness over cleverness: verbose, meaningful names and explicit control flow.
- Modularize: group related functionality into cohesive modules with well-defined interfaces.
- Do not use legacy or deprecated patterns; prefer modern, widely accepted practices.

Naming
- Use long, descriptive identifiers (e.g., `playerHealthPercent`, not `hpPct`).
- Use `PascalCase` for types/classes, `camelCase` for functions and local variables, and `UPPER_SNAKE` for constants.
- Avoid abbreviations unless widely understood in the codebase.

Modularization & Structure
- Encapsulate related functions and data in modules or classes; export a minimal public API.
- Group functions topically (initialization, event handlers, helpers, public API) and place them in separate files when a module grows.
- Keep files small: ~200–400 lines recommended; break larges files into submodules.

File Structure (Required Order)
- Module initialization must always be the first executable code in a file.
- This includes:
  - Lua addon loading pattern (e.g., `local _, addonTable = ...`)
  - AceAddon/AceModule initialization
  - Any framework-specific module bootstrap
- No variables, helper functions, or logic may appear before module initialization.
- Variables should be declared:
  - Inside the function where they are used, OR
  - After module initialization if shared across multiple functions
- Avoid top-level variables unless they require shared access across the module.
- Prefer local scope over file-level scope to reduce unintended side effects.

Function Design & Size
- Do NOT create trivial functions.
  - Avoid functions that are only 4–5 lines if the logic could be written clearly at the call site.
  - Do not extract single-use functions unless it significantly improves readability.
- Prefer inlining over unnecessary abstraction.
  - If a function is only called once and is simple, keep the logic inline.
- Functions should generally be between 25–40 lines.
  - This is a guideline, not a strict limit.
- Break up functions when:
  - The function becomes difficult to read or reason about
  - Logical responsibilities can be clearly separated
  - Parts of the logic are reused in multiple places
- Do NOT split functions into multiple smaller ones if it results in:
  - Many single-use helper functions
  - Reduced readability due to excessive jumping between definitions
- Modularization should only be applied when:
  - Logic is reused in multiple places, OR
  - A function becomes too large or complex to remain readable
- Prioritize readability and cohesion over strict size limits.

WoW API Usage (Modern Only)
- Target ONLY the latest World of Warcraft retail patch APIs.
- Do NOT implement legacy, deprecated, or fallback API support.
- Forbidden:
  - Version checks (e.g., checking game version or API availability)
  - Conditional logic for old vs new APIs
  - “Fallback” implementations for older patches
  - Supporting Classic, Wrath, or other non-retail clients unless explicitly requested
- Always use the current, official API even if older alternatives exist.
- If an API has changed, update usage to the modern version instead of maintaining backward compatibility.

Libraries & Dependencies
- Prefer well-known, maintained libraries when they solve core problems (config, persistence, UI components).
- Do not add heavy or uncommon dependencies without justification and a migration/upgrade plan.

Code Organization & Comments
- Use section headers (commented separators) to split files into logical parts (Initialization, API, Helpers).
- Inline comments only where the intent is non-obvious; prefer descriptive names to reduce comment noise.
- Regex should always be accompanied by a comment explaining the pattern and what it matches.
- Avoid comments that restate what the code does; focus on why or any non-obvious details.
- Do NOT use docstrings or large comment blocks; keep comments concise and relevant to the code they accompany.
- Functions that are not trivial must include a comment directly above them describing their purpose.
- The purpose comment should explain what the function does and why it exists (if not obvious).
- Simple functions (e.g., one-liners or self-explanatory logic) do not require comments.
- Complex or non-obvious logic must include inline comments explaining the reasoning behind the implementation.
- Prefer clear and descriptive naming, but never rely on naming alone when intent may be unclear.

Section Headers (Required)
- Use the following exact format for section headers in Lua files:

-----------------------------------
-- Section Name
-----------------------------------

- The number of dashes must match exactly (35 characters).
- Always include a space after `--`.
- Use Title Case for section names.
- Add a blank line before each section header.
- Do not add a blank line after the section header.

TOC File Formatting (Lua Addons)
- Always include a blank line between the addon metadata section and the module/file load list.
- Make sure the metadata section is formatted correctly with the required fields (Title, Notes, Version) and that the file list is accurate and complete.
- Author is required and should be set to github username or real name of the primary maintainer.
- Version should follow semantic versioning (e.g., 1.0.0) and be updated with each release.

Correct example:
## Title: My Addon
## Notes: Description here
## Version: 1.2.3

file1.lua
file2.lua

README.md Structure (Required)

- Every project must include a README.md file following a clear, structured format.
- The README must be concise, readable, and focused on what the addon does and how to use it.
- Avoid unnecessary verbosity or generic filler text.

Required Sections (All Projects)

# Addon Name

## Overview
- Short description of what the addon does.
- Explain the primary purpose and problem it solves.
- Keep it concise (2–5 sentences).

## Features
- Bullet-point list of key functionality.
- Focus on user-facing behavior, not implementation details.

## Installation
- Clear steps for installing into the `Interface/AddOns/` directory.
- Include `/reload` or restart instructions where appropriate.

## License
- State the license (typically GPL v3) and reference the LICENSE file.

Conditional Sections (Include When Applicable)

## Usage
- Include if the addon has commands, UI interaction, or user workflows.
- Explain how to access and use the addon in-game.

## Modules
- Include only if the addon is modular.
- List each module with a short description of its responsibility.

## Options
- Include if the addon has configuration.
- Describe available settings and what they control.

## Saved Variables
- Include if the addon uses or intentionally avoids saved variables.
- Clearly state behavior (persistent vs session-only).

## Implementation Notes
- Include only for technical or developer-focused addons.
- Describe hooks, API usage, or important internal behavior.
- Keep concise; do not over-document trivial details.

## Compatibility
- Include if the addon depends on Blizzard UI or may conflict with other addons.

Style & Formatting Rules
- Use Markdown headers exactly as shown (## Section Name).
- Keep descriptions concise and direct.
- Use bullet points for features and lists.
- Do NOT include unnecessary badges, shields, or decorative elements.
- Do NOT include development logs, changelogs, or roadmap sections in README (use separate files if needed).
- Write from a user perspective first, developer perspective second.

Formatting & Style
- Use consistent indentation and spacing; adopt spaces (4) or project convention. Match existing code style.

What to Avoid
- Global mutable state unless necessary; prefer configuration objects and dependency injection.
- Large, sweeping refactors in a single change.
- Adding tooling or build complexity without clear benefit to contributors.
- Global table _G pollution; use local variables and module tables.
- Clever or non-obvious code that sacrifices readability for brevity.
- Unnecessary abstraction or over-engineering; keep it simple.

Git & Version Control (Restricted)
- Version control actions must always be performed by a human.
- Agents must NOT perform any git or version control operations.
- This includes (but is not limited to):
  - Creating commits
  - Writing commit messages
  - Creating, switching, or deleting branches
  - Rebasing, merging, or squashing
  - Pushing or pulling changes
  - Modifying git history in any way

When in Doubt
- Ask a human reviewer with context — don’t guess broadly impactful changes.

Usage Example (agent checklist)
- 1) Create a short TODO plan.
- 2) Apply small patch implementing change.
- 3) Run a syntax/lint check.
- 4) Summarize changes and request human review.

---
This file defines style rules intended for cross-project reuse; adapt minor details to project conventions when necessary.
