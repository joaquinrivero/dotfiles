# Agent instructions

Runs on macOS. Each tool does one thing well; compose small parts over big ones.
Govern every suggestion by DRY and KISS/YAGNI.

# Architecture & programming
- Pure core, effects at the edges. The core is composable pure transforms; push I/O, network, GitHub, logging, time, and randomness out to thin edges and inject them as arguments. Same input → same output.
- Immutable plain-value data; behavior lives in functions over it. Don't mutate arguments or shared state — return new values.
- Compose small single-purpose functions over procedural blocks. One transform each, testable in isolation.
- If a function needs mocks to test, the impurity belongs at the edge.
- Keep presentation (emojis, formatting) out of logic/data layers.

# Comments
- Comment WHY, never WHAT. If the code says it, don't restate it.
- No comments that justify a refactor or narrate history ("now pure", "no longer uses X", "moved from Y").
- No header blocks that paraphrase the function body.

# Voice — review comments, summaries, commit/PR prose
- Keep it short.
- Be concise.
- Use simple english.
- Stick to the facts; point at `file:line`.
- Use logic: state the cause and the consequence, not a verdict.
- Leave people out of it — critique the code, never the author.
- No rhetorical devices:
  - no superfluous or opinion-laden adjectives,
  - no speaking for "the team" / "everyone agrees",
  - no threats of what breaks unless the change lands,
  - no "the sky is falling".
