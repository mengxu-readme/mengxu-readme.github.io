# Changelog

## 1.0.13 - 2026-07-29

- Added an `apple-touch-icon` link to `_includes/head.liquid`. Without it, "Add to Home Screen" on iOS falls back to a screenshot of the page instead of the site icon, because Safari only reads `rel="apple-touch-icon"` for that thumbnail — it never uses `rel="shortcut icon"`. The link is emitted only when a raster asset actually exists: a new optional `apple_touch_icon` config key (resolved under `/assets/img/` like `icon`, or used verbatim when it is a rooted path or an absolute URL), otherwise an `icon` that is itself a `.png`/`.jpg`/`.jpeg` file. The default emoji `icon` renders as an inline SVG data URI, which Safari ignores for touch icons, so in that case nothing is emitted rather than a link that would 404. Apple's recommended asset is a 180x180 PNG. Fixes alshedivat/al-folio#2774.
- Fixed the favicon `<link>` being emitted with an empty filename when no `icon` is configured. `site.icon != blank` is always true under plain Liquid — the `blank` literal compares by calling `blank?` on the other operand, and neither `nil` nor `String` defines it without ActiveSupport, so the comparison returns `nil` and `!=` inverts it to `true`. An unset `icon` therefore reached the image branch and produced `href="/assets/img/"`, a guaranteed 404 on every page. The check is now truthiness plus an explicit empty-string test.
- Rendered video publication previews as `<video>` instead of a broken `<img>` (`_layouts/bib.liquid`). `preview = {clip.mp4}` in a `.bib` entry was passed straight to the image path, so the publications list showed a broken-image placeholder. Previews ending in `.mp4`, `.webm`, `.ogg` or `.mov` are now handed to `_includes/video.liquid` with `controls=true`; local files still resolve under `/assets/img/publication_preview/` and remote URLs are passed through unchanged. The image branch is untouched, so nothing changes for existing previews. Fixes alshedivat/al-folio#3564.
- Made `_includes/video.liquid` recognize `.mov` files, and normalize the extension before matching it (lower-casing it and dropping any query string). A `CLIP.MP4` or a `clip.mp4?raw=1` URL previously fell through to the `<iframe>` branch and rendered as an empty frame. Local `.mov` files did the same.
- Constrained `video.preview` in `_sass/_publications.scss`. Unlike `<img>`, a `<video>` has no intrinsic responsive sizing and falls back to its 300x150 default, which overflowed the publication thumbnail column.

## 1.0.12 - 2026-07-27

- Switched the default repository/user stat-card service from the unmaintained `github-readme-stats.vercel.app` to the actively maintained `github-stats-extended.vercel.app` fork (`_includes/repository/repo.liquid`, `_includes/repository/repo_user.liquid`). The public github-readme-stats instance has been unreliable for a long time, leaving repository cards blank; the fork is API-compatible, so every existing query parameter (`theme`, `locale`, `show_owner`, `description_lines_count`, `show_icons`) keeps working and the cards render identically. Requested upstream by a github-stats-extended maintainer in alshedivat/al-folio#3629.
- Stat-card service URLs now resolve through a `default:` fallback instead of interpolating `site.external_services.*` directly. Previously a site without an `external_services` block emitted a relative `/api/pin/?…` URL and every card 404'd; the service is still fully overridable for self-hosting. Applied to the trophy card as well (`_includes/repository/repo_trophies.liquid`), which keeps `github-profile-trophy.vercel.app`.
- Updated the in-template locale-code documentation links to the fork's `docs/advanced_documentation.md#available-locales`.
- Fixed `og:image` and `twitter:image` emitting relative asset paths (`_includes/metadata.liquid`). External scrapers (Discord, LinkedIn, Mastodon, Slack) cannot resolve a relative image URL, so shared link previews rendered without an image. Relative values are now prefixed with `site.url` + `site.baseurl`, matching how `og:url` is already built; values that are already absolute (contain `://`) are left untouched so a user-supplied CDN URL is not double-prefixed. Fixes alshedivat/al-folio#3666.
- Fixed mobile submenus rendering off-screen (`_sass/_navbar.scss`). Inside the collapsed navbar the dropdown inherited `position: absolute` and `right: 0` from the base Tailwind rule, which anchored it past the left edge of the viewport — measured at `left: -85.7px` on a 393px screen, leaving the menu items unreadable. Below the `sm` breakpoint the menu is now statically positioned, left-aligned, and wraps long entries. Fixes alshedivat/al-folio#3663. Thanks to @bibliophilecoder.
- Made those mobile submenus span the full navbar width. The mobile block sets `align-items: flex-start` on `.navbar-menu-list`, so each nav item is a shrink-to-fit flex item and the dropdown's `width: 100%` resolved against the toggle link rather than the navbar (102.5px inside a 361px navbar). The item owning a dropdown is now stretched, and the two adjacent `max-width: 575.98px` blocks are merged into one.

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
