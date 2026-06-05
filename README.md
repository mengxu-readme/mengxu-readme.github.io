# al-search

`al_search` provides the search experience for `al-folio` v1.x.

## What it owns

- Search runtime payload and setup logic
- Keyboard shortcut and navbar modal open behavior
- Search asset packaging (plugin-owned, not `al_folio_core`)

## Installation

```ruby
gem 'al_search'
```

```yaml
plugins:
  - al_search
```

## Usage

Render assets where your layout expects search runtime:

```liquid
{% al_search_assets %}
```

## Ecosystem context

- Starter wiring/integration tests live in `al-folio`.
- Search runtime behavior and component correctness tests live in this plugin.

## Contributing

Search behavior and runtime asset updates should be proposed in this repository.
