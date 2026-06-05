# al-analytics

`al_analytics` provides analytics integrations for `al-folio` v1.x and compatible Jekyll sites.

## Supported providers

- Google Analytics
- Cronitor Analytics
- Pirsch Analytics
- OpenPanel Analytics

## Installation

```ruby
gem 'al_analytics'
```

```yaml
plugins:
  - al_analytics
```

## Usage

Configure analytics in `_config.yml`:

```yaml
enable_cookie_consent: false

enable_google_analytics: true
google_analytics: "G-XXXXXXXXXX"

enable_cronitor_analytics: false
cronitor_analytics: "XXXXXXXXX"

enable_pirsch_analytics: false
pirsch_analytics: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

enable_openpanel_analytics: false
openpanel_analytics: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
```

Render scripts in your layout:

```liquid
{% al_analytics_scripts %}
```

Legacy `analytics:` hash configuration is still supported.

## Ecosystem context

- Starter wiring happens in `al-folio` (`Gemfile` + `_config.yml`).
- Consent/runtime coordination can be combined with `al_cookie`.

## Contributing

Provider/runtime changes belong here. Starter-only docs/demo updates belong in `al-folio`.
