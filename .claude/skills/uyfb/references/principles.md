# Principles

Each principle has a trigger, a rule, and a sign that you skipped it.
Read the entry before you apply it.
In the reply, name it only with the exact decision it changed.

## Core

### Laziness Protocol

- **When.** Sizing a diff, refactoring, or tempted to add an abstraction, a layer, or a new signal passed through many layers.
- **Rule.** Get the most result with the least code.
  Look for deletions before additions.
  Keep the call chain flat.
  If one question needs more than 3 files or layers to answer, flatten it.
  Make each decision in one place and pass the result down.
  When a task asks you to thread a new value through types, schemas, and pipelines, stop and look for a direct path.
  Remove small pass-throughs and duplicated choices before they spread.
- **Skipped it.** A human would find the code tiring to maintain.

### Foundational Thinking

- **When.** Before writing logic.
- **Rule.** Get the data shape right first.
  Define the core types, list every way the data is read, and pick structures that fit the main paths.
  Remove duplicated structure, not every similar line.
  Three similar lines beat an early abstraction.
  Build what every later step needs first (shared types, test setup, CI).
  Before sharing state between actors, ask "what happens if another actor changes this at the same time?"
  If the answer is not "nothing", isolate it.
- **Skipped it.** A new feature is spread across callers as special cases instead of living in one abstraction.

### Redesign from First Principles

- **When.** A new requirement must fit into an existing design.
- **Rule.** Design as if the requirement had been there from day one.
  Then move the code toward that design.
- **Skipped it.** The new requirement is bolted on with a flag and a branch in each place it touches.

### Attack the Premise

- **When.** Two or more fixes that share one assumption have failed the same check.
- **Rule.** Write the shared assumption down in one sentence.
  Before the next fix, write a script that counts the imbalance per actor (per worker, per file, per request).
  If the same few actors hold it every run, find what gives them that role and remove the asymmetry.
  Do not add work that compensates for it.
  If the count is even, the premise is not the cause. Look elsewhere and keep the count as evidence.
- **Skipped it.** A third fix built on the same assumption as the first two.

### Subtract Before You Add

- **When.** Ordering an addition, a refactor, or a rewrite.
- **Rule.** Remove dead code, unused validators, and stale references first.
  Then build on the simpler base.
- **Skipped it.** New code works around old code that nothing uses.

### Minimize Reader Load

- **When.** Shaping or reviewing code that is hard to follow.
- **Rule.** Count two things: the layers between a question and its answer, and the hidden or mutable state the reader must hold.
  Inline wrappers with one caller and adapters with one implementation.
  A layer must change the abstraction, not repeat the same methods.
  Prefer return values over mutation, locals over fields, fields over module state.
  Derive values instead of keeping two copies in sync.
  State an invariant once at the boundary, not in every consumer.
- **Skipped it.** A new reader cannot answer "where does X come from?" and "what can change X?" in 30 seconds.

### Outcome-Oriented Execution

- **When.** A planned rewrite or migration with clear phases.
- **Rule.** Aim at the target design.
  Planned, scoped, reversible breakage in the middle is fine.
  Do not write throwaway compatibility code to keep every middle step perfect.
  Full static and runtime checks are required at the end.
- **Skipped it.** A temporary shim that will outlive the migration.

### Experience First

- **When.** A product, UX, or scope tradeoff.
- **Rule.** Choose what is best for the user over what is easiest to build.
  Ship fewer polished features over more rough ones.
- **Skipped it.** The reason for a UX choice is "it was simpler to implement".

### Exhaust the Design Space

- **When.** A new interaction or architecture decision with no precedent in the codebase.
- **Rule.** Build 2 or 3 competing prototypes and compare them side by side before you commit to one.
- **Skipped it.** The first idea shipped, and no alternative was ever tried.

### Build the Lever

- **When.** Any work that is not trivial: edits, migrations, analysis, checks.
- **Rule.** Build the tool that does the work or proves it: a codemod, a script, a generator, a rerunnable check.
  Do the first unit by hand to learn the recipe, then build the tool and check it against your hand result.
  Make it safe to rerun.
  A script that handles every unit in one pass beats doing each unit by hand.
  Build the smallest script that works, never a framework.
- **Skipped it.** You cite this principle, but there is no script, codemod, or check in the diff or the scratch folder.

### Never Block on the Human

- **When.** Tempted to ask "should I do X?" about reversible work.
- **Rule.** Do X, show the result, and say why.
  The human corrects after the fact.
  Irreversible actions still need confirmation.
  Product direction comes from the human. Execution does not wait for them.
- **Skipped it.** The human came back to a question instead of a result.

## Architecture

### Model the Domain

- **When.** Stateful logic, code with many branches, or the same shape assumption repeated across files.
- **Rule.** Put the domain into a structure:
  a state machine instead of scattered booleans,
  a typed model instead of loose parameters,
  a table, registry, or tagged union instead of branches across files,
  a reducer or event model instead of ad hoc mutation,
  a module per body of knowledge instead of per step (load, validate, save).
  Do not force it: boring code is fine when the shape is clear, local, and not growing.
- **Skipped it.** A new feature adds one more branch to an if/else chain, or a second boolean must stay in sync with the first.

### Boundary Discipline

- **When.** Wiring validation, error handling, or framework adapters.
- **Rule.** Validate at system boundaries: CLI args, config, network, external APIs, files.
  Inside, trust the types and do not validate again.
  Keep business logic in pure functions. The framework shell stays thin.
  Do not leak wire, storage, or framework types through the public surface.
- **Skipped it.** Null checks deep in a call chain that the boundary already guaranteed.

### Type System Discipline

- **When.** Designing types or a function signature in a typed language.
- **Rule.** Make illegal states impossible to write: use sum types (Rust enums with data) instead of a bag of optional fields.
  Wrap primitives that mean different things (`UserId`, `OrderId`) in their own types.
  Parse external data into typed models at the boundary.
  Do not lie to the compiler with casts or `unwrap` on facts you did not prove.
  Make every match exhaustive, so a new variant breaks the build where it must be handled.
  Derive types from the real schema instead of copying it by hand.
  Make a type stronger only where a runtime check or panic shows it is too weak.
- **Skipped it.** You could write a comment that explains which field combinations are valid.

### Make Operations Idempotent

- **When.** Commands, lifecycle steps, or loops that can crash, restart, or retry.
- **Rule.** Running the step twice, or after a partial run, ends in the same state as running it once.
  Check the current state and converge to the target, instead of assuming a clean start.
- **Skipped it.** A retry creates a duplicate, or fails because the first run half-finished.

### Migrate Callers Then Delete Legacy APIs

- **When.** A new internal API arrives while old callers still exist.
- **Rule.** Move every caller and delete the old API in the same change.
  No compatibility layer, no old and new paths side by side.
  Check each rename against the files, including strings, docs, and back-references.
- **Skipped it.** Two ways to do the same thing remain after the change.

### Separate Before Serializing Shared State

- **When.** Two actors (threads, processes, tasks) might write the same file, branch, key, or object.
- **Rule.** First remove the sharing: give each actor its own file, key, branch, or worktree, and merge only where the data is read.
  Only when one shared target is a real invariant, serialize it by structure: a lock, a single writer, sequential phases, compare-and-swap.
  A written convention is not concurrency control.
- **Skipped it.** "We need a lock" was the first answer.

## Verification

### Prove It Works

- **When.** Before you say a task is done.
- **Rule.** Check the real thing, not a proxy.
  Run the feature, read the actual stored value, look at the real screen, check the process directly.
  A file timestamp, a cached screenshot, a self-report, or "it compiles" is not proof.
  When a check fails, suspect the check before the system.
  The best proof is a script that reruns the same comparison, with its output kept for the reviewer.
- **Skipped it.** The reply says "should work" or "tests pass" with no output from the real surface.

### Fix Root Causes

- **When.** Debugging.
- **Rule.** Reproduce first.
  Ask "why" until you reach the cause, and fix it there.
  A guard that silences a crash is a symptom fix.
  If a workaround needs a long comment to defend it, the code is wrong.
  Search for the same pattern elsewhere and fix every instance.
  When stuck, add logging and read real output. Do not guess.
  When something fails only after a restart, suspect stale saved state (config, cache, lock files) before code.
- **Skipped it.** You cannot explain why it broke, only what you changed.

### Sequence Work into Verifiable Units

- **When.** Multi-step work: sweeps, migrations, runs of similar edits, and how you order commits.
- **Rule.** Split work into small units.
  Each unit goes from a known good state, through one change, to a check that passes, before the next starts.
  Order commits so they tell the story: the failing test first, then the fix.
  Or: the deletion first, then the reshape.
- **Skipped it.** Ten changes, one check at the end, and a failure you cannot place.

### Test Behavior, Not Implementation

- **When.** Writing, changing, or keeping a test.
- **Rule.** Call the code the way its users do, with one concrete input, and assert a literal expected output or a visible effect.
  Ask: would this test still pass if every function it imports returned nothing?
  If yes, rewrite the assertion or delete the test.
  Bad shapes: no real assertion, only "was called" checks, expected value computed by the code under test, a test that restates a constant, a test that only reads its own fixture.
- **Skipped it.** The test cannot fail for a real defect.

### Explain the Number

- **When.** Before you trust, report, or act on a number you measured: speed, latency, throughput, an eval score.
- **Rule.** Ask "why is it not twice as good?" and name the limit (a core, a lock, the disk, the network, the load generator) from a profile or counters, not from reading code.
  List what else the number could measure (errors, cached or skipped work, an untuned side, noise, a part too small to matter) and rule out each with evidence.
  Keep run count, spread, and the limit next to the number.
- **Skipped it.** A number with no run count, no spread, or no named limit.

## Meta

### Encode Lessons in Structure

- **When.** You write the same instruction a second time, or the human corrects the same thing twice.
- **Rule.** Turn it into a mechanism: a type that cannot hold the bad state, then a lint or a failing test, then a shared helper, then a runtime check.
  Pick the strongest one that fits.
  Then delete the text instruction.
  If it truly needs judgment, make the text more visible and add an example of the failure.
- **Skipped it.** "I will keep that in mind" with nothing written to a file.
