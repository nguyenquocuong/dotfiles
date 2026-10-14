# Bug fix

**You own this. Plan, review, verify.**

Be scientific.
Every line you ship traces back to runtime evidence.
A change that "might help" is a hypothesis, not a fix, and it does not ship.
When evidence rules out a hypothesis, revert what it made you change.
Ship the smallest change the evidence supports.

1. **Reproduce it yourself** on the same surface the user saw it: the GUI, the CLI, the API.
   Launch the app and drive it the way the user does.
   If it does not reproduce, make the trigger yourself, tighten the conditions, or add logging until it fires.
   Ask the user to reproduce only with a specific reason you cannot reach the surface, and only after you went as far as you can.
2. **Find the cause by elimination.**
   List the candidate causes.
   Each round, run the test that rules out the most candidates, and read real output.
   When program state is unclear, add logging and read it while the code runs. Do not guess.
   Check git history for a regression (`git log`, `git bisect`).
   Confirm the surviving cause with runtime evidence before you plan the fix.
3. **Plan the fix.**
   Name the data shape it touches.
   Search for the same pattern elsewhere and fix every instance.
4. **Write a failing test first** when a cheap test path exists.
   It must fail for the bug, not for a typo.
   Skip it with a reason when the test would be costly or unclear.
5. **Fix it** with the smallest change the evidence supports.
6. **Verify on the same surface as step 1.**
   The original repro now passes.
   "Inconclusive" or "checked on a different surface" is not a pass. Say so.
   Unit tests show branch behavior, not that the bug is gone.
7. **Finish** (see SKILL.md).
   Order commits so the failing test lands before the fix.

**Reply.** What was broken, the root cause, the fix, how you verified.
Paste the failing and then passing repro output as it is.
