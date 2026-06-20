# Commit Message Examples

Comprehensive examples organized by type and scenario.

## Contents

- [By Type](#by-type)
- [By Scenario](#by-scenario)
- [Breaking Changes](#breaking-changes)
- [Multi-Scope](#multi-scope)
- [With Body and Footer](#with-body-and-footer)
- [Anti-Examples](#anti-examples)

## By Type

### feat - New Features

```
feat: add email notifications on order status

feat(auth): implement OAuth2 login with Google

feat(search): add fuzzy matching for product names

feat(cart): support multiple shipping addresses

feat(api): add pagination to list endpoints
```

### fix - Bug Fixes

```
fix: prevent duplicate form submissions

fix(auth): handle expired refresh tokens gracefully

fix(ui): correct button alignment on mobile viewport

fix(db): resolve connection pool exhaustion under load

fix(payments): retry failed webhooks with exponential backoff
```

### docs - Documentation

```
docs: update API authentication examples

docs(readme): add Docker installation instructions

docs(contributing): clarify PR review process

docs(api): document rate limiting headers
```

### style - Formatting

```
style: apply prettier formatting to components

style(lint): fix eslint warnings in auth module

style: standardize import ordering
```

### refactor - Code Restructuring

```
refactor: extract validation logic to separate module

refactor(auth): replace callback pattern with async/await

refactor(api): consolidate error handling middleware

refactor: rename User to Account across codebase
```

### perf - Performance

```
perf: lazy load dashboard widgets

perf(db): add index for user email lookups

perf(api): implement response caching with Redis

perf(ui): virtualize long product lists

perf: reduce bundle size by code splitting routes
```

### test - Testing

```
test: add integration tests for checkout flow

test(auth): cover edge cases in token refresh

test(api): add load testing for search endpoint

test: increase coverage for payment module to 90%
```

### build - Build System

```
build: upgrade webpack to v5

build(deps): update React to 18.2

build: add production optimization flags

build(docker): reduce image size with multi-stage build
```

### ci - Continuous Integration

```
ci: add GitHub Actions workflow for PRs

ci: parallelize test suite across 4 runners

ci(deploy): add staging environment pipeline

ci: cache npm dependencies between runs
```

### chore - Maintenance

```
chore: update .gitignore for IDE files

chore: configure husky pre-commit hooks

chore(deps): remove unused lodash dependency

chore: update copyright year in license
```

### revert - Reverts

```
revert: "feat(auth): add biometric login"

This reverts commit abc123def456.

Biometric API not available on target devices.
```

## By Scenario

### Initial Setup

```
chore: initial project setup

feat: scaffold basic application structure

build: configure TypeScript and ESLint
```

### Database Changes

```
feat(db): add user preferences table

fix(db): resolve migration ordering issue

perf(db): add composite index for activity queries

refactor(db): normalize address storage
```

### API Development

```
feat(api): add POST /users endpoint

fix(api): return 404 instead of 500 for missing resources

docs(api): add OpenAPI specification

perf(api): implement request deduplication
```

### Security Fixes

```
fix(security): sanitize user input in search

fix(auth): prevent timing attacks on password comparison

fix(deps): update lodash to patch prototype pollution
```

### Dependency Updates

```
build(deps): update all patch versions

build(deps): upgrade TypeScript 4.9 to 5.0

chore(deps): remove deprecated request library

fix(deps): pin problematic transitive dependency
```

## Breaking Changes

### With Exclamation Mark

```
feat(api)!: require authentication for all endpoints

feat!: drop support for Node.js 14

fix(config)!: rename DATABASE_URL to DB_CONNECTION_STRING

refactor(api)!: change response envelope structure
```

### With Footer

```
feat(api): change user endpoint response format

The user object now nests address fields under an address
object for consistency with other endpoints.

BREAKING CHANGE: Clients must update to access address
fields via user.address.street instead of user.street.
Affected fields: street, city, state, zip, country.
```

### With Both (Required for Major Changes)

```
feat(auth)!: replace session tokens with JWTs

Migrate from server-side sessions to stateless JWTs for
better horizontal scaling. Session storage no longer needed.

BREAKING CHANGE: All clients must update authentication
handling. Sessions are no longer stored server-side.
Existing sessions will be invalidated on deploy.

Migration guide: docs/jwt-migration.md
Fixes #892
```

## Multi-Scope

```
fix(auth,api): sync session timeout between layers

feat(ui,api): add real-time notifications

refactor(db,api): extract shared validation schemas

test(auth,payments): add E2E tests for purchase flow
```

## With Body and Footer

### Explaining Context

```
fix(payments): retry failed webhook deliveries

Third-party payment processor occasionally returns 503
during their maintenance windows. Implement exponential
backoff retry (1s, 2s, 4s, 8s, 16s) before marking
webhook as permanently failed.

Max retry window: ~30 seconds
Permanent failure triggers alert to ops channel

Fixes #456
Refs #123
```

### Co-Authored Commits

```
feat(search): implement fuzzy matching algorithm

Add Levenshtein distance calculation for typo tolerance.
Supports up to 2 character differences for words > 5 chars.

Co-authored-by: Alice Smith <alice@example.com>
Co-authored-by: Bob Jones <bob@example.com>
```

### Referencing Multiple Issues

```
fix(auth): handle concurrent session invalidation

Race condition when user logs out from multiple devices
simultaneously could leave orphaned session records.

Fixes #234
Fixes #267
Refs #189
```

## Anti-Examples

### Too Vague

```
# BAD
fix: fixed it
fix: bug fix
feat: updates
chore: stuff

# GOOD
fix(auth): resolve null pointer on missing user
fix(cart): prevent negative quantity values
feat(search): add autocomplete suggestions
chore(deps): update testing dependencies
```

### Wrong Tense

```
# BAD
feat: added new feature
fix: fixed the bug
docs: updated readme

# GOOD
feat: add new feature
fix: resolve the bug
docs: update readme
```

### Redundant Type in Subject

```
# BAD
fix: fix the login bug
feat: feature for dark mode
docs: documentation update

# GOOD
fix: resolve login timeout
feat: add dark mode support
docs: clarify setup instructions
```

### Too Long

```
# BAD (87 chars)
feat(authentication): add the ability for users to reset their password via email link

# GOOD (42 chars)
feat(auth): add password reset via email

The password reset flow sends a secure one-time link
valid for 24 hours. Users can set a new password
without knowing their current one.
```

### Missing Scope When Helpful

```
# UNCLEAR
fix: handle null response

# CLEAR
fix(payments): handle null response from Stripe
```
