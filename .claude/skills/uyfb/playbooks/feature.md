# Feature

**You own the design. Plan, build, verify.**

1. **Understand.**
   Read the affected subsystem and its tests.
   Read the project's design docs and decisions before changing a design.
2. **Walk the user's path.**
   For each action, ask "what does the user expect here?" and name what would break that.
   Choose the user's result over the easy build (Experience First).
3. **Name the data shape** and the structure that organizes it (Model the Domain), before any logic.
4. **Design.**
   If the design has no precedent in the codebase, sketch 2 or 3 designs and compare them in a table.
   Integrate the new requirement as if it was there from day one (Redesign from First Principles).
5. **Build in small checked units** (Sequence Work into Verifiable Units).
   Test first, then the simplest code that passes, then refactor.
   Delete before you add.
6. **Verify on the real surface.**
   Launch the app and drive the new behavior the way the user will.
   "Inconclusive" or wrong surface is not a pass. Say so.
7. **Attack the design when it is contested.**
   Reread the whole diff as a hostile reviewer: wrong results, missing failure paths, untested behavior, code that does not match its neighbors.
   Fix each real finding, or say why it is not one.
8. **Finish** (see SKILL.md).
   Commits go in small ordered steps.

**Reply.** What you built and for whom, what you chose and why, open decisions.
Use tables for design alternatives.
