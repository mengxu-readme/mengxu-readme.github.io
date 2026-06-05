# Changelog

## 1.0.11 - 2026-06-02

- Added `onerror` handlers to all repository stat-card images (`repo.liquid`, `repo_user.liquid`, `repo_trophies.liquid`). When the external github-readme-stats or github-profile-trophy service is unavailable the entire card is now hidden gracefully instead of showing broken alt-text.
- Added CSS for `.af-popover` and `.af-tooltip` in `_sass/_utilities.scss`. The vanilla fallback popover/tooltip implementation in `tooltips-setup.js` (used when bootstrap-compat is disabled) creates elements with these class names, but they previously had no positioning or visual styling — making them appear as unstyled, unpositioned text. They are now absolutely positioned, styled with theme colors, and have appropriate z-index.

## 1.0.10 - 2026-06-01

- Replaced leftover jQuery `$(...)` calls with vanilla JS in the publications "N more authors" expander (`_layouts/bib.liquid`) and the responsive-image `onerror` fallback (`_includes/figure.liquid`). Since jQuery was removed in v1 these threw `ReferenceError: $ is not defined` at runtime — the author list never expanded and the broken-image fallback never ran.
- Fixed `main.css` cache-busting. The theme's `bust_css_cache` digested a non-existent `assets/_sass` directory and therefore always produced the MD5 of an empty string, so `main.css`'s `?v=` query never changed and returning visitors could be served stale CSS after a theme/color update. It now digests the theme's actual `_sass` partials.

## 1.0.9 - 2026-05-24

- Retried interrupted `jekyll-minifier` file writes so Jupyter notebook conversion does not fail builds with transient `Errno::EINTR`.

## 1.0.8 - 2026-05-24

- Fixed book-review inline CSS typos and contained floated cover figures within the article flow.

## 1.0.7 - 2026-02-18

- Fixed Tocbot active indicator color to use al-folio theme color instead of Tocbot default green.
- Removed extra custom list rail styling from sidebar TOC to avoid duplicated/misaligned ridges.
- Added frontmatter-driven TOC collapse controls via `toc.collapse` (`expanded` or `auto`) and optional `toc.collapse_depth`.

## 1.0.6 - 2026-02-18

- Removed unnecessary navbar menu cross-axis alignment to keep the theme toggle vertically aligned with adjacent controls.
- Updated Tocbot sidebar styling to a Tocbot-native single-rail hierarchy (with al-folio colors) and removed custom per-link ridge markers.

## 1.0.5 - 2026-02-18

- Restored right-aligned desktop navbar menu layout with explicit core-owned alignment classes.
- Matched inline code typography more closely to legacy sizing/weight while preserving code-block styling.
- Normalized related-post recommendation links to regular font weight.
- Fixed Tocbot sidebar visual clashes by removing competing custom rails and scoping active/hover indicators cleanly.

## 1.0.4 - 2026-02-17

- Fixed related-posts HTML structure to render valid list markup.
- Restored sidebar TOC behavior and styling via Tocbot runtime integration.
- Added Tailwind-first vanilla table engine for `pretty_table` pages when Bootstrap compatibility is disabled.
- Replaced remaining jQuery-dependent runtime scripts (masonry, jupyter link handling) with vanilla JS.
- Improved project hover lift, teaching calendar toggle UX, and schedule/table styling parity.

## 1.0.3 - 2026-02-17

- Restricted gem packaging to tracked runtime files to prevent accidental inclusion of local/untracked artifacts.

## 1.0.2 - 2026-02-17

- Extracted icon runtime ownership from core into plugin include wrappers.
- Removed duplicated search runtime payload ownership from core (`assets/js/search/**`).
- Switched back-to-top runtime to pinned CDN contract and fixed script load ordering.
- Replaced opaque `tabs.min.js` with provenance-tracked `tabs.js`.

## 1.0.1 - 2026-02-16

- Fixed cache-bust asset lookup to resolve plugin assets from both Bundler git paths (`bundler/gems/*`) and RubyGems install paths (`gems/*`).
- Added runtime guard coverage for RubyGems-installed plugin asset resolution.

## 1.1.0 - 2026-02-10

- Delegated CV and Distill rendering to `al_folio_cv` and `al_folio_distill`.
- Removed CV/Distill templates and distill runtime assets from core ownership.
- Merged `al_utils` tags/filters into core (`details`, `file_exists`, `hideCustomBibtex`, `remove_accents`).

## 1.0.0 - 2026-02-08

- Initial release.
- Added v1 API contract checks and legacy content migration warnings.
