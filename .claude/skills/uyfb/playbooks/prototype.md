# Prototype

**You own the decision, not the code.
The prototype is a throwaway tool.
The real build follows Feature.**

This is the one playbook where speed beats polish.
Code quality does not matter.
The rigor is in choosing the right design cheaply.
Propose variants the user did not ask for.
Throw an approach away and try another.

1. **Name the decision** the prototype must make: which layout, which interaction, which behavior, which approach is faster.
   No decision means no prototype. Go to Feature.
2. **Look for prior art** when the design space is open.
   Skip this when the direction is already set.
3. **Build it in a scratch folder** outside the project, never in production source.
   For a visual question, the lightest stack that renders the idea.
   For a behavior or timing question, the smallest script that exercises it.
   No framework, no tests, no abstractions.
4. **Put variants side by side.**
   For visual work, one page with a switcher and a label per variant.
   For behavior, one script that runs each variant and prints the result.
5. **Observe the thing you are deciding.**
   Screenshot each variant and drive the interaction, or log the timing and print the output.
   The observation is the test.
6. **Decide.**
   Present variants, evidence, tradeoffs, and a recommendation.
   Hand the chosen direction to Feature.

**Reply.** The variants, the evidence (screenshots, output, timings), tradeoffs, your recommendation, and the scratch path.
Say plainly that the prototype is throwaway.
