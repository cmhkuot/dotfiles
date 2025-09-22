# Commit Message Generation Instruction

Generate commit messages following the **Conventional Commits** standard. Ensure messages are concise (maximum **20 words**) and summarize changes across all modified files.

## Format

```plaintext
<type>: [scope] <short description>
<description> (if needed, provide additional details)
```

### Type (required)

Use one of the following prefixes based on the nature of the changes:

- **feat**: New feature
- **fix**: Bug fix
- **chore**: Maintenance or tooling update
- **refactor**: Code refactoring (no feature change)
- **perf**: Performance optimization
- **docs**: Documentation updates
- **test**: Adding or updating tests
- **style**: Code style updates (e.g., formatting, missing semi-colons)
- **ci**: Changes to CI/CD
- **build**: Changes affecting the build system or dependencies

### Scope (optional)

Placed inside square brackets **after the colon**. Represents the name of the affected module, feature, or component (e.g., `[auth]`, `[button]`, `[api]`, `[state]`).

### Short Description (required)

- Clear, concise summary of the changes.
- Maximum **20 words**.

### Description (optional, but recommended for complex changes)

- Provide more context about why the change was made.
- Explain the approach taken or any important details.
- Keep it brief and to the point.

## Rules

- Summarize all modified files in a single commit message.
- Use present tense (e.g., "fix" instead of "fixed").
- No punctuation at the end.
- No capital letters except for proper nouns or acronyms.

## Examples

feat: [button] add disabled state prop

- Added `disabled` prop to button component for accessibility compliance
- Updated button styles to reflect disabled state

fix: [auth] resolve login redirection issue

- Fixed incorrect redirection after login due to missing token validation
- Updated unit tests for better coverage

refactor: [api] improve error handling for requests

- Standardized error response format across API endpoints
- Improved logging for debugging failed requests

perf: [state] optimize Zustand store updates

- Reduced unnecessary re-renders by optimizing state selectors
- Improved performance in large-scale component trees

chore: [deps] update next.js to latest version

- Upgraded Next.js from v12 to v13
- Fixed compatibility issues with existing plugins
