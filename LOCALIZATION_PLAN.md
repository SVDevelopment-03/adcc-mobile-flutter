(The file `d:\adcc-mobile-flutter\LOCALIZATION_PLAN.md` exists, but is empty)
**Goal**: Restore repository to a clean state and safely complete localization across all pending files listed in `text_usage_map.md`.

1. Validate repo state
	- Ensure repository is reset to `HEAD` and build artifacts/backups removed.
	- Run `dart analyze` and `flutter gen-l10n` to confirm baseline.

2. Read mapping
	- Open `text_usage_map.md` and produce a list of pending files that require localization.

3. Localize files (automated + review)
	- For each pending file:
	  - Create a backup `.bak` copy.
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

# Localization continuation plan

## Goal
Restore the repo to a stable localization pass and continue the work file-by-file in the same order as `text_usage_map.md`, validating each file before marking it done.

## Working method used
- Work strictly one file at a time.
- Read the file from the map in order.
- Check whether the strings are already localized or need ARB additions.
- Update the relevant localization keys in `lib/l10n/app_en.arb` and `lib/l10n/app_ar.arb` when needed.
- Run `flutter gen-l10n` after the ARB update.
- Run `dart analyze` on the edited file.
- Only then mark the file as done in `text_usage_map.md`.
- Do not skip ahead or work randomly.

## Current status
This project is in the middle of a real, repo-specific localization pass. The work already completed includes the following verified items:

- `lib/core/navigation/club_store_details_loader.dart`
- `lib/core/navigation/community_details_loader.dart`
- `lib/core/services/permission_service.dart`
- `lib/core/theme/app_colors.dart`
- `lib/features/auth/view/communityScreen/auth_action_card.dart`
- `lib/features/auth/view/communityScreen/community.dart`
- `lib/features/auth/view/login_screen.dart`
- `lib/features/auth/view/otpScreen/otp.dart`
- `lib/features/auth/view/register_screen.dart`
- `lib/features/auth/view/registrationScreen/create_account.dart`
- `lib/features/auth/view/setupProfile/setup_profile_screen.dart`
- `lib/features/challenges/view/challenge_accepted_screen.dart`
- `lib/features/challenges/view/challenge_details_screen.dart`

These were verified with `dart analyze` and, where ARB changes were needed, with `flutter gen-l10n` as well.

## Important project notes
- The repo already has generated localization support via Flutter `gen-l10n`.
- The correct access pattern is `AppLocalizations.of(context)!`.
- Some files required cleanup for `const` usage and deprecated APIs such as `withOpacity`.
- The l10n file currently shows a non-blocking deprecation warning for `synthetic-package` in `l10n.yaml`; it does not block generated localization or analysis.
- `text_usage_map.md` is treated as the source of file order, but it contains duplicates and stale entries. The actual flow should stay sequential, not random.

## Resume order
Continue from the next pending file in `text_usage_map.md`, in order, starting from:

1. `lib/features/auth/view/email_password_login_screen.dart`
2. `lib/features/challenges/view/leaderboard_screen.dart`
3. `lib/features/challenges/view/my_challenges_screen.dart`
4. `lib/features/challenges/view/sections/accepted_difficulty_section.dart`
5. ...and so on through the remaining map entries in order.

## Safe continuation checklist
When resuming work:
- Open the next file from the map.
- Check if hardcoded `Text(...)` strings need localization keys.
- Update the ARB files only if the string is not already available.
- Run `flutter gen-l10n`.
- Run `dart analyze` on the current file.
- Mark it done only if the analyzer passes.
- Move to the next file.

## Final note for later resumption
If the credit budget runs out, reopen this plan file and continue from the next pending file listed above, without skipping or reordering entries. The goal is to finish the map in order and keep every file validated before it is marked complete.



