(The file `d:\adcc-mobile-flutter\LOCALIZATION_PLAN.md` exists, but is empty)
**Goal**: Restore repository to a clean state and safely complete localization across all pending files listed in `text_usage_map.md`.

1. Validate repo state
	- Ensure repository is reset to `HEAD` and build artifacts/backups removed.
	- Run `dart analyze` and `flutter gen-l10n` to confirm baseline.

2. Read mapping
	- Open `text_usage_map.md` and produce a list of pending files that require localization.

3. Localize files (automated + review)
      - For each pending file:
	  - Replace safe literal `Text('...')` occurrences with generated localization getters (e.g. `AppLocalizations.of(context)!.text_0XXX`) only where appropriate.
	  - Convert any `.replaceAll` usages on localization tear-offs into proper `AppLocalizations.of(context)!.text_0XXX(arg1, ...)` calls preserving parameter order.
	  - Avoid placing `AppLocalizations.of(context)!` inside `const` expressions; remove `const` only where necessary.
	  - Run `dart analyze` on the modified file and fix any remaining `non_constant_list_element` or const-related errors.
	  - Commit the file-level change (one commit per feature folder preferred).

4. Update ARB files
	- Append added keys to `lib/l10n/app_en.arb` using JSON-safe writes.
	- Add Arabic translations to `lib/l10n/app_ar.arb` (machine suggestion allowed but mark for human review).
	- Run `flutter gen-l10n` and verify the generated `AppLocalizations` API.

5. Verify and finalize
	- Run `dart analyze` and address blocking errors only (do not chase non-critical lints).
	- Run the app (or widget tests) for spot-checks of changed screens.
	- Push commits and open a PR with a description of changes and files that need human translation review.

Notes and safeguards
 - Always create `.bak` before editing; keep changes small and commit frequently.
 - Preserve UI logic and avoid changing formatting beyond localization changes.
 - If a file contains complex ICU/plural forms, leave the key insertion but flag for manual translation.

Next action: run the localization pass across all pending files listed in `text_usage_map.md` (automated, silent; report when complete). Reply "go" to start.

