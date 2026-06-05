# al-folio-core

`al_folio_core` is the core runtime/theme gem for `al-folio` v1.x.

## Responsibilities

- Validate v1 config contract (`al_folio.api_version`, Tailwind/Distill runtime keys)
- Emit migration warnings for legacy Bootstrap-marked content when compat mode is off
- Provide shared layouts/includes/runtime primitives for starter sites
- Provide built-in utility tags/filters (`details`, `file_exists`, `hideCustomBibtex`, `remove_accents`)
- Ship migration manifests consumed by `al_folio_upgrade`
- Exclude legacy Bootstrap/MDB and plugin-owned duplicate runtime assets

## Delegated features

`al_folio_core` delegates feature ownership to focused plugins:

- `al_folio_distill` for Distill layouts/runtime
- `al_folio_cv` for CV rendering
- `al_cookie` for cookie consent
- `al_icons` for icon runtime
- `al_search` for search runtime payload

## Theme usage

```yaml
theme: al_folio_core
plugins:
  - al_folio_core
```

## Ecosystem context

- Starter/orchestration and visual integration tests live in `al-folio`.
- Component-level correctness tests belong in owning plugin repos.

## Contributing

Core runtime/layout contracts belong here. Feature-specific behavior should be routed to the owning plugin repository.
