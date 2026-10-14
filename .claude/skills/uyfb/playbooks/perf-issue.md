# Perf issue

**You own the measurement story.**
Tie every fix to a measurement.
Do not read source instead of measuring.

1. **Capture a baseline** on the real surface, with a profile or trace.
   Run it several times and record the spread.
   Vet it with Explain the Number: name the limit and rule out what else it could measure.
2. **Form hypotheses from the profile**, not from reading code.
   Try the performance moves in order, cheapest first, and stop at the first that meets the target:
   1. Do not do it. Stop work whose result nothing uses.
   2. Do it, but not again (cache, memoize).
   3. Do it less.
   4. Do it later.
   5. Do it when the user is not looking.
   6. Do it in parallel.
   7. Do it cheaper.
3. **Fix one thing at a time.**
   Measure after each attempt before the next (Sequence Work into Verifiable Units).
   Revert attempts that did not help.
4. **Compare the artifacts** with a script, not by eye.
   "Inconclusive" or a different surface is not a pass. Say so.
5. **Finish** (see SKILL.md).
   Put the numbers in the commit message.

**Reply.** Baseline number, after number, the change, run count and spread, the named limit, and the artifact path.
