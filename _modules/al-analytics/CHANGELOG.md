# Changelog

## 0.1.1 - 2026-02-07

- Fixed a Liquid compatibility bug by renaming the internal `blank?` helper to avoid conflict with Liquid parser internals.
- Added unit tests for analytics rendering, legacy config fallbacks, and cookie-consent attribute injection.

## 0.1.0 - 2026-02-07

- Initial gem release.
- Added support for modern al-folio analytics config keys with legacy `analytics:` fallback.
- Added optional cookie-consent script attributes and provider enable flags.
