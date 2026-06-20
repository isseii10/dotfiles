# Conventional Commits Specification

Complete specification for commit message formatting.

## Contents

- [Format Structure](#format-structure)
- [Type Definitions](#type-definitions)
- [Scope Guidelines](#scope-guidelines)
- [Subject Rules](#subject-rules)
- [Body Guidelines](#body-guidelines)
- [Footer Format](#footer-format)
- [Breaking Changes](#breaking-changes)
- [Semantic Versioning](#semantic-versioning)
- [Commitlint Rules](#commitlint-rules)

## Format Structure

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

### Components

| Component | Required | Description |
|-----------|----------|-------------|
| type | Yes | Category of change |
| scope | No | Area of codebase affected |
| subject | Yes | Brief description |
| body | No | Detailed explanation |
| footer | No | Metadata, references, breaking changes |

## Type Definitions

### Primary Types (SemVer Impact)

| Type | Description | Version Bump |
|------|-------------|--------------|
| `feat` | New feature for users | MINOR (0.x.0) |
| `fix` | Bug fix | PATCH (0.0.x) |

### Secondary Types (No Direct SemVer Impact)

| Type | Description |
|------|-------------|
| `docs` | Documentation only changes |
| `style` | Formatting, whitespace, semicolons (no code change) |
| `refactor` | Code restructuring without feature/fix |
| `perf` | Performance improvements |
| `test` | Adding or correcting tests |
| `build` | Build system, external dependencies |
| `ci` | CI configuration files and scripts |
| `chore` | Maintenance tasks, tooling |
| `revert` | Reverting previous commits |

### Type Selection Guide

**feat** - Adds new capability visible to users
- New endpoint, UI feature, CLI command
- NOT internal refactoring users don't see

**fix** - Corrects incorrect behavior
- Bug causing wrong output
- Crash, error handling issue
- NOT style fixes or refactoring

**refactor** - Changes code without changing behavior
- Rename variables, extract functions
- Restructure files, improve readability
- MUST NOT change external behavior

**perf** - Improves performance
- Optimize algorithm, add caching
- Reduce memory usage
- Often overlaps with refactor

**style** - Only formatting changes
- Whitespace, indentation
- Missing semicolons, quotes
- NO functional changes

## Scope Guidelines

### Purpose

Scope identifies the section of codebase affected. Optional but helpful for larger projects.

### Format

- Lowercase
- Single word or hyphenated
- Noun describing area

### Common Patterns

**By Feature/Module:**
```
auth, cart, search, payments, notifications
```

**By Layer:**
```
api, ui, db, core, middleware
```

**By Technology:**
```
deps, config, docker, ci, build
```

**By Component:**
```
button, modal, header, sidebar
```

### Multi-Scope

Separate with commas when change spans areas:
```
fix(auth,api): sync timeout handling
```

### When to Omit

- Change is truly global
- Scope doesn't add clarity
- Project is small/simple

## Subject Rules

### The 7 Rules

1. **Separate from body with blank line**
2. **Limit to 50 characters** (72 absolute max)
3. **Capitalize first letter**
4. **No trailing period**
5. **Use imperative mood**
6. **Be specific and descriptive**
7. **Don't repeat the type**

### Imperative Mood

Write as command/instruction:

| Wrong | Right |
|-------|-------|
| Added feature | Add feature |
| Fixes bug | Fix bug |
| Changed behavior | Change behavior |
| Updating docs | Update docs |

**Test:** "If applied, this commit will _[subject]_"

### Length Guidelines

```
# Good (43 chars)
Add password reset via email

# Acceptable (67 chars)
Add password reset flow with email verification and rate limiting

# Too long (89 chars) - move details to body
Add the ability for users to reset their password via a secure email link with expiration
```

## Body Guidelines

### When to Include

- Change needs explanation beyond subject
- Motivation isn't obvious from diff
- Side effects or related changes exist
- Migration steps needed

### What to Include

- **What** changed (if not obvious)
- **Why** it changed (motivation)
- **Context** (related issues, decisions)
- **NOT how** (code shows that)

### Format

- Blank line after subject
- Wrap at 72 characters
- Use paragraphs for readability
- Bullet points for lists

### Example

```
fix(payments): handle webhook race condition

The payment processor occasionally sends duplicate webhooks
within milliseconds. Without idempotency checking, this
caused double-charging customers.

Changes:
- Add idempotency key to webhook handler
- Store processed webhook IDs in Redis with 24h TTL
- Return 200 for duplicate webhooks (already processed)

Tested with simulated duplicate webhooks at 10ms intervals.
```

## Footer Format

### Issue References

```
Fixes #123          # Closes issue when merged
Closes #456         # Alternative to Fixes
Refs #789           # References without closing
See #101            # Informal reference
```

### Co-Authors

```
Co-authored-by: Name <email@example.com>
Co-authored-by: Other <other@example.com>
```

### Breaking Changes

```
BREAKING CHANGE: description of what breaks
```

### Multiple Footers

```
Fixes #234
Refs #189
Co-authored-by: Alice <alice@example.com>
BREAKING CHANGE: Remove deprecated v1 endpoints
```

## Breaking Changes

### Indicators

Two ways to indicate breaking changes:

**1. Exclamation mark in header:**
```
feat(api)!: remove deprecated endpoints
```

**2. Footer (more detail):**
```
BREAKING CHANGE: The /v1/users endpoint has been removed.
Use /v2/users with the new response format instead.
```

**Best practice:** Use both for major changes.

### What Constitutes Breaking

- Removing public API endpoints
- Changing response/request formats
- Renaming configuration options
- Changing default behavior
- Dropping support for versions/platforms

## Semantic Versioning

Conventional commits map to semver:

| Commit Type | Version Bump | Example |
|-------------|--------------|---------|
| BREAKING CHANGE | MAJOR | 1.0.0 → 2.0.0 |
| feat | MINOR | 1.0.0 → 1.1.0 |
| fix | PATCH | 1.0.0 → 1.0.1 |
| perf | PATCH | 1.0.0 → 1.0.1 |
| Others | None | No release |

### Pre-1.0 Behavior

Before 1.0.0 (development phase):
- BREAKING CHANGE → MINOR (0.x.0)
- feat/fix → PATCH (0.0.x)

## Commitlint Rules

Common validation rules for automated checking:

### Type Rules

```javascript
'type-enum': [2, 'always', [
  'feat', 'fix', 'docs', 'style', 'refactor',
  'perf', 'test', 'build', 'ci', 'chore', 'revert'
]],
'type-case': [2, 'always', 'lower-case'],
'type-empty': [2, 'never']
```

### Scope Rules

```javascript
'scope-case': [2, 'always', 'lower-case'],
'scope-empty': [2, 'never']  // if required
```

### Header Rules

```javascript
'header-max-length': [2, 'always', 72],
'header-full-stop': [2, 'never', '.']
```

### Body Rules

```javascript
'body-leading-blank': [2, 'always'],
'body-max-line-length': [2, 'always', 72]
```

### Footer Rules

```javascript
'footer-leading-blank': [2, 'always']
```

## Sources

- [Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)
- [How to Write a Git Commit Message](https://cbea.ms/git-commit/)
- [Angular Commit Guidelines](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit)
- [Commitlint Reference](https://commitlint.js.org/reference/rules.html)
