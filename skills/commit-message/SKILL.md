---
name: commit-message
description: |
  Generates well-formatted conventional commit messages following the official specification.
  Use when user asks to "write a commit message", "help with my commit", "format this commit",
  "what should my commit say", "conventional commit", or wants to review/improve existing
  commit messages. Also triggers on requests involving changelogs, semantic versioning from
  commits, or commit linting issues.
---

# Git Commit Helper

Generate conventional commit messages that enable automated changelogs and semantic versioning.

## Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Quick Reference

| Type | Purpose | SemVer |
|------|---------|--------|
| `feat` | New feature | MINOR |
| `fix` | Bug fix | PATCH |
| `docs` | Documentation only | - |
| `style` | Formatting, no code change | - |
| `refactor` | Code change, no feature/fix | - |
| `perf` | Performance improvement | PATCH |
| `test` | Adding/updating tests | - |
| `build` | Build system, dependencies | - |
| `ci` | CI configuration | - |
| `chore` | Maintenance, tooling | - |
| `revert` | Revert previous commit | - |

**Breaking changes** → MAJOR version (use `!` or footer)

## The 7 Rules

1. **Separate subject from body with blank line**
2. **Limit subject to 50 characters** (72 hard max)
3. **Capitalize the subject line**
4. **No period at end of subject**
5. **Use imperative mood** ("Add" not "Added")
6. **Wrap body at 72 characters**
7. **Body explains what and why, not how**

**Imperative test:** "If applied, this commit will _[subject]_"

## Workflow

1. Analyze the diff or change description
2. Identify primary type (see decision tree below)
3. Determine scope if changes are focused on one area
4. Write subject: imperative, ≤50 chars, no period
5. Add body if context needed (what/why, not how)
6. Add footer for issues or breaking changes only
7. **Present the message to the user and wait for approval before running git commit**

> **Note:** Do NOT add `Co-Authored-By` trailers to commit messages.

## Type Decision Tree

```
Is it a new capability for users?
├─ Yes → feat
└─ No → Does it fix a bug?
         ├─ Yes → fix
         └─ No → Does it improve performance?
                  ├─ Yes → perf
                  └─ No → Is it restructuring code?
                           ├─ Yes → refactor
                           └─ No → Is it tests only?
                                    ├─ Yes → test
                                    └─ No → Is it docs only?
                                             ├─ Yes → docs
                                             └─ No → build/ci/chore
```

## Common Scopes

Choose based on project structure:

| Category | Examples |
|----------|----------|
| Features | `auth`, `cart`, `search`, `payments` |
| Layers | `api`, `ui`, `db`, `core` |
| Tech | `deps`, `config`, `build`, `ci` |

Keep scopes consistent within project. Avoid file names as scopes.

## Examples

**Simple feature:**
```
feat(auth): add password reset flow
```

**Bug fix with body:**
```
fix(api): handle null response from payment provider

Payment provider returns null for declined cards instead of
an error object. Add null check before processing response.

Fixes #234
```

**Breaking change:**
```
feat(api)!: change user endpoint response format

BREAKING CHANGE: User endpoint returns nested address object
instead of flat fields. Clients must update to use
user.address.street instead of user.street.
```

**Multiple scopes:**
```
fix(auth,api): sync session timeout handling
```

See `references/examples.md` for more patterns.

## Footers

```
Fixes #123
Closes #456
Refs #789
BREAKING CHANGE: description
```

## Common Mistakes

| Wrong | Right | Why |
|-------|-------|-----|
| `fixed bug` | `fix: resolve null pointer` | Imperative mood |
| `Add feature.` | `Add feature` | No period |
| `add feature` | `Add feature` | Capitalize |
| `Updated stuff` | `refactor(auth): extract validation` | Be specific |
| `fix: Fix the bug` | `fix: resolve login timeout` | Don't repeat type |

## References

- `references/examples.md` - Comprehensive examples by type
- `references/specification.md` - Full conventional commits spec

Sources: [Conventional Commits](https://www.conventionalcommits.org/), [How to Write a Git Commit Message](https://cbea.ms/git-commit/), [commitlint](https://commitlint.js.org/)
