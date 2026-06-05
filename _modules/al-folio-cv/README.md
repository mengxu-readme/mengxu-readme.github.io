# al-folio-cv

`al_folio_cv` is the CV rendering plugin for `al-folio` v1.x.

## What it provides

- Shared CV templates used by `layout: cv`
- CV helper Liquid tag: `{% al_folio_cv_render %}`
- Packaged stylesheet at `/assets/css/al-folio-cv.css`

## Installation

```ruby
gem 'al_folio_cv'
```

```yaml
plugins:
  - al_folio_cv
al_folio:
  features:
    cv:
      enabled: true
```

`al_folio_core` delegates `layout: cv` rendering to this plugin.

## Ecosystem context

- Starter examples/docs live in `al-folio`.
- CV runtime and rendering behavior are owned here.

## Contributing

CV layout/rendering changes should be proposed in this repository.
