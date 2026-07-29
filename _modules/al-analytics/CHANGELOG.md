# Changelog

## 1.0.2 - 2026-07-29

- Added support for Cloudflare Web Analytics via `cloudflare_analytics` (token) and `enable_cloudflare_analytics` (flag). The beacon is only emitted when a token is present, so an unset token renders nothing rather than a beacon tag with an empty `data-cf-beacon` token. As with the other token-bearing providers, the flag defaults to on when a token is set and `false` turns the provider off explicitly, the legacy `analytics.cloudflare` key is still honored, and `enable_cookie_consent` adds the `type="text/plain" data-category="analytics"` attributes so the script only runs after consent.

## 1.0.1 - 2026-07-27

- Added support for Simple Analytics via `enable_simple_analytics`. The provider has no site key, so it is controlled by the flag alone and honors `enable_cookie_consent` like every other provider.

## 0.1.1 - 2026-02-07

- Fixed a Liquid compatibility bug by renaming the internal `blank?` helper to avoid conflict with Liquid parser internals.
- Added unit tests for analytics rendering, legacy config fallbacks, and cookie-consent attribute injection.

## 0.1.0 - 2026-02-07

- Initial gem release.
- Added support for modern al-folio analytics config keys with legacy `analytics:` fallback.
- Added optional cookie-consent script attributes and provider enable flags.
