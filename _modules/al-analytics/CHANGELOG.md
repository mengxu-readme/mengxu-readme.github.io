# Changelog

## 1.0.1 - 2026-07-27

- Added support for Simple Analytics via `enable_simple_analytics`. The provider has no site key, so it is controlled by the flag alone and honors `enable_cookie_consent` like every other provider.

## 0.1.1 - 2026-02-07

- Fixed a Liquid compatibility bug by renaming the internal `blank?` helper to avoid conflict with Liquid parser internals.
- Added unit tests for analytics rendering, legacy config fallbacks, and cookie-consent attribute injection.

## 0.1.0 - 2026-02-07

- Initial gem release.
- Added support for modern al-folio analytics config keys with legacy `analytics:` fallback.
- Added optional cookie-consent script attributes and provider enable flags.
