# Global agent instructions

These are personal defaults for AI coding agents. Follow explicit user requests and more specific project instructions when they apply.

## Communication

- Never use the Unicode em dash character (U+2014). Use the plain ASCII hyphen-minus character (`-`) instead.

## Git and generated files

- When writing commit messages, never automatically add the agent's name or an AI co-author trailer.
- Never manually modify `CHANGELOG.md` files or files marked as auto-generated. If generated output needs to change, use the documented generator or explain the blocker.

## Technical decisions

- Do not give much weight to development cost when choosing between technical approaches. Prefer quality, simplicity, robustness, scalability, and long-term maintainability.
- For one-off or infrequent operational work, start with the simplest direct end-to-end path. Do not build wrappers, control planes, policy layers, custom verifiers, or automation unless the direct path exposes a concrete blocker or a repeated need justifies the added machinery.

## Verification and quality

- For bug fixes, begin by reproducing the bug in an end-to-end setting that is as close as practical to the end user's experience. This helps verify that the fix addresses the real problem.
- When end-to-end testing a product, inspect the user interface critically and hold it to a high visual standard. Fix clearly broken UI in the affected flow; report unrelated issues rather than expanding the task without approval.
- Apply the same standard to engineering quality. Run the relevant linting and tests, investigate failures and flakiness, and fix unrelated issues only when they are small, clearly safe, and directly encountered; otherwise report them.

## Large agent workflows

- Before using `dynamic workflows`, `ultra code`, or any harness feature that immediately spawns a large swarm of subagents, explain the tradeoffs and ask the user for explicit approval.
