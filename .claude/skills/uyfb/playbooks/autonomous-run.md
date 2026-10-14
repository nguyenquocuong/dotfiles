# Autonomous run

**You own the exit condition.
Define done, then drive to it without stopping.**

1. **State the exit condition** as a check that passes or fails, before the first round.
   Examples: all tests green, the repro passes, zero old callers left, pixel diff is zero.
2. **Pick how to wait.**
   For background work the harness tracks, it wakes you when done.
   For outside state (CI, a deploy), poll at the speed that state changes.
   Never sleep in a loop to wait.
3. **Each round:** the smallest change the evidence supports, then check it against the exit condition.
   Keep what moved it forward.
   Revert what did not.
4. **Problems found on the way are yours.**
   A broken tool, a flaky test, a related bug: fix it in its own change, then return to the exit condition.
   Do not park reversible work for the human.
   Stop only for actions on the pause list, a product call no experiment can settle, or a real dead end.
5. **Keep a decision log** in a scratch folder outside the project: one row per round with what changed and whether the exit condition moved.
6. **Stop when the exit condition passes.**
   A plateau is not a stop. Change approach and push past it.
   Report a real dead end instead of spinning.
   Never weaken the exit condition to declare victory.

**Reply.** The exit condition, rounds run, what landed, what was reverted, the final state of the check, and the decision log path.
