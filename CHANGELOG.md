# Changelog

## 1.0.3 - 2026-07-27

- Replaced the full `site.pages` scan used to find the home page title with a single `where`/`map`/`first` filter chain in the generated search data.
- Added regression coverage asserting the home navigation entry resolves the title of the page whose permalink is `/`.

## 1.0.2 - 2026-02-17

- Hardened navbar search button handling by binding `#search-toggle` directly to `openSearchModal`.
- Added regression coverage for the button-triggered modal-open path.

## 1.0.1 - 2026-02-17

- Made search modal open/close behavior plugin-owned and jQuery-free.
- Added vanilla navbar-collapse handling for search button interactions.

## 1.0.0 - 2026-02-16

- Promoted search plugin to stable v1.0 runtime contract for al-folio.

## 0.1.0 - 2026-02-07

- Initial gem release.
- Added standalone search assets and generated search data payload integration.
