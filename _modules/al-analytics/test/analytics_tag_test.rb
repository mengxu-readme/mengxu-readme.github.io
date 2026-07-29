require 'minitest/autorun'
require 'liquid'

require_relative '../lib/al_analytics'

class AlAnalyticsTagTest < Minitest::Test
  Site = Struct.new(:config)

  def render_scripts(config)
    template = Liquid::Template.parse('{% al_analytics_scripts %}')
    template.render({}, registers: { site: Site.new(config) })
  end

  def test_renders_google_with_cookie_consent_attributes
    output = render_scripts(
      'enable_cookie_consent' => true,
      'google_analytics' => 'G-TEST123'
    )

    assert_includes output, 'googletagmanager.com/gtag/js?id=G-TEST123'
    assert_includes output, 'gtag("config", "G-TEST123")'
    assert_includes output, 'type="text/plain" data-category="analytics"'
  end

  def test_renders_legacy_analytics_hash
    output = render_scripts(
      'analytics' => { 'google' => 'G-LEGACY' }
    )

    assert_includes output, 'G-LEGACY'
  end

  def test_respects_explicit_disable_flags
    output = render_scripts(
      'google_analytics' => 'G-DISABLED',
      'enable_google_analytics' => false
    )

    refute_includes output, 'googletagmanager.com'
  end

  def test_renders_openpanel_when_enabled
    output = render_scripts(
      'openpanel_analytics' => '123e4567-e89b-12d3-a456-426614174000',
      'enable_openpanel_analytics' => true
    )

    assert_includes output, 'openpanel.dev/op1.js'
    assert_includes output, 'clientId: "123e4567-e89b-12d3-a456-426614174000"'
  end

  def test_renders_cloudflare_when_enabled
    output = render_scripts(
      'cloudflare_analytics' => 'abcdef0123456789abcdef0123456789',
      'enable_cloudflare_analytics' => true
    )

    assert_includes output, 'static.cloudflareinsights.com/beacon.min.js'
    assert_includes output, %(data-cf-beacon='{"token": "abcdef0123456789abcdef0123456789"}')
    refute_includes output, 'type="text/plain"'
  end

  def test_renders_cloudflare_with_cookie_consent_attributes
    output = render_scripts(
      'enable_cookie_consent' => true,
      'cloudflare_analytics' => 'abcdef0123456789abcdef0123456789'
    )

    assert_includes output, 'static.cloudflareinsights.com/beacon.min.js'
    assert_includes output, 'type="text/plain" data-category="analytics"'
  end

  def test_renders_cloudflare_from_legacy_analytics_hash
    output = render_scripts(
      'analytics' => { 'cloudflare' => 'cf-legacy-token' }
    )

    assert_includes output, %(data-cf-beacon='{"token": "cf-legacy-token"}')
  end

  def test_skips_cloudflare_without_a_token
    assert_equal '', render_scripts('enable_cloudflare_analytics' => true)
    assert_equal '', render_scripts('enable_cloudflare_analytics' => true, 'cloudflare_analytics' => '   ')
  end

  def test_respects_explicit_cloudflare_disable_flag
    output = render_scripts(
      'cloudflare_analytics' => 'abcdef0123456789abcdef0123456789',
      'enable_cloudflare_analytics' => false
    )

    refute_includes output, 'cloudflareinsights.com'
  end

  def test_renders_simple_analytics_when_enabled
    output = render_scripts(
      'enable_simple_analytics' => true
    )

    assert_includes output, 'scripts.simpleanalyticscdn.com/latest.js'
    refute_includes output, 'type="text/plain"'
  end

  def test_renders_simple_analytics_with_cookie_consent_attributes
    output = render_scripts(
      'enable_cookie_consent' => true,
      'enable_simple_analytics' => true
    )

    assert_includes output, 'scripts.simpleanalyticscdn.com/latest.js'
    assert_includes output, 'type="text/plain" data-category="analytics"'
  end

  def test_skips_simple_analytics_unless_flag_is_set
    assert_equal '', render_scripts({})
    assert_equal '', render_scripts('enable_simple_analytics' => false)
  end

  def test_skips_blank_identifiers
    output = render_scripts(
      'pirsch_analytics' => '   ',
      'cronitor_analytics' => nil
    )

    refute_includes output, 'api.pirsch.io'
    refute_includes output, 'rum.cronitor.io'
  end
end
