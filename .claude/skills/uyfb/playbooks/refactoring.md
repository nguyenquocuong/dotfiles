# Refactoring

**You own the contract.
The structure changes.
The behavior does not.**

If the cleanup finds a missing feature or a real bug, split it out.
Ship the structural change first, against the pinned behavior.
A redesign is allowed, but name it and switch to Feature.

1. **Pin the behavior first.**
   Learn the contract of the code.
   Write characterization tests, snapshots, or an old-vs-new equivalence script that captures current behavior before any structure moves.
   Typecheck and lint are not a pin.
2. **Name the structure the code is missing** (Model the Domain).
   The new shape must delete branches or invalid states, not add indirection.
   Boring code stays when its shape is already clear and local.
3. **Name the target shape**: module layout, types, call graph, as if built today.
   If the shape has no precedent in the codebase, compare 2 or 3 shapes before you move.
4. **Subtract first.**
   Delete dead code, inline one-caller wrappers, drop redundant checks, remove stale references.
   A cleanup that "might help" gets reverted.
5. **Move in small steps**, each keeping the pin green.
   For an API change, migrate every caller and delete the old API in the same change.
   No shims, no old and new paths side by side.
   Check every rename against the files, including strings, docs, and comments.
   Use a codemod or script for mechanical edits (Build the Lever).
6. **Prove behavior is unchanged** on the real artifact, not "it compiles".
   For a large reshape, run the equivalence script or a smoke run of the app.
7. **Check it was worth it.**
   The goal is less reader load.
   If the diff does not reduce reader load somewhere, revert it.
8. **Finish** (see SKILL.md).
   Commit order: the deletion, then the reshape, then any follow-up cleanup.

**Reply.** The structure that changed, the pin it was held against, the equivalence proof, the reader-load change, what shipped and what was reverted.
No new behavior.
