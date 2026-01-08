## 0.0.13

- Added support for forwarding inherited getters and methods from parent classes in the draft generation process.
- Introduced `_getForwardedGetters` and `_getForwardedMethods` functions to retrieve unique getters and methods from a class and its supertypes, excluding those from the Object type.
- Created new integration tests to verify the functionality of inherited members in draft classes.

## 0.0.12

- Reapplied the "split actions" feature, enhancing the workflow organization.
- Merged updates from the main branch to ensure compatibility and incorporate recent changes.

## 0.0.11

- Reverted the "split actions" feature.
- Improved code formatting and linting in the generator file.
- Updated the changelog to reflect recent changes, including pipeline fixes.

## 0.0.10

- Added support for making external types draftable, allowing extensions on classes to be annotated with `@draft`.
- Introduced new tests to verify the functionality of draftable extensions, ensuring correct behavior when creating and manipulating draft instances.

## 0.0.9

- Introduced a new method for accessing models, improving data retrieval efficiency.
- Enhanced the structure of actions for better organization and clarity.

## 0.0.8

- Pipeline fixes

## 0.0.7

- Pipeline fixes

## 0.0.6

- Upgrade source_gen to 4.0.0 (thanks again @tomwyr!)

## 0.0.5

- Fix positional params code generation (thanks @tomwyr!)

## 0.0.4

- Upgrade deps

## 0.0.3

- Add support for positional parameters
- Add support for empty constructors
- Update documentation

## 0.0.2

- Update dependencies

## 0.0.1

- Initial version.
