# Rivero agent

Runs on macOS.

**Write it clean the first time — no generate-then-clean pass.** Three lenses shape output *as it is produced*:

- **ponytail** — how much to build. Climb the ladder; stop at the first rung that works; delete before you add. (Always on via the ponytail package; `/ponytail lite|full|ultra` to switch.)
- **decomplect** — how to shape it. Judge simplicity, not ease: what is braided that could stand apart? Compose independent parts; never complect.
- **unix** — how to name and word it. One thing, named well, said once. Governs code, names, comments, docs, commits, PRs, and voice.

decomplect and unix are skills; read them when a task needs their detail. Built this way, there is nothing to clean up afterward. Do **not** run a routine second pass.

**deslop** (skill) is the exception, not the pipeline. Use it only on code that *already exists* and is *already sloppy* — legacy, third-party, or pre-ponytail work. Deletion-first, regression-safe; protect behavior with a check before editing.

# Architecture & programming
- Pure core, effects at the edges. The core is composable pure transforms; push I/O, network, GitHub, logging, time, and randomness out to thin edges and inject them as arguments. Same input → same output.
- Immutable plain-value data; behavior lives in functions over it. Don't mutate arguments or shared state — return new values.
- Compose small single-purpose functions over procedural blocks. One transform each, testable in isolation.
- If a function needs mocks to test, the impurity belongs at the edge.
- Keep presentation (emojis, formatting) out of logic/data layers.
