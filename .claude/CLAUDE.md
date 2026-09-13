# Cuong's agent instructions

These are common instructions for Cuong's agents across all scenarios.

# General Guidelines

- Never use the em dash "—". Use plain dash "-" instead
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated
- When writing or substantially editing long Markdown files, put each full sentence on its own line.
  Preserve normal Markdown structure, but avoid wrapping multiple sentences onto one physical line.
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible.
  This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
  If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
  If you see one, even if it is not caused by what you are working on right now, still get it fixed.

# Verification and Honesty

- Never claim something works without having run it.
  If you could not verify something, say exactly what was not verified.
- After any change, run the project's lint, typecheck, and tests before reporting done.
  If they fail, show the actual output, do not summarize it away.
- When a task is partially blocked, finish everything else and state explicitly what was left out and why.

# Git

- Never run `git push --force`, `git reset --hard`, `git checkout -- .`, or delete branches without explicit confirmation.
- When writing commit messages, NEVER auto-add your agent name as co-author.
- Never commit unless asked.
  When asked, use conventional commits (`feat:`, `fix:`, `docs:`, ...) and keep each commit to one logical change.
- Never amend or rebase commits that have already been pushed.

# Environment

- The shell is fish, not bash.
  Use fish syntax for any command you tell me to run, for example `set -x X Y` instead of `export X=Y`.
- The OS is Arch Linux.
  Use `pacman` or `yay` for packages, never `apt`. Use `systemctl` for services.
- Do not run `sudo` commands without asking first.

# Communication

- Keep responses short and precise.
  No preamble, no restating the question, no closing summary unless something needs my attention.
- I am a non-native English speaker.
  Use simple, direct English: short sentences, common words, no idioms or slang.
- When asking a question, give your recommended answer first, then ask.
