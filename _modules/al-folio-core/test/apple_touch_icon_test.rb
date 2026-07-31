# frozen_string_literal: true

require_relative "test_helper"
require "liquid"

# Regression test for the missing `rel="apple-touch-icon"` link.
# See https://github.com/alshedivat/al-folio/issues/2774 — without it, adding a site to
# an iOS home screen produces a screenshot thumbnail instead of the site icon.
#
# The tag must never be emitted speculatively: the default `icon` is an emoji rendered
# as an inline SVG data URI, and Safari ignores SVG for apple-touch-icon, so pointing
# the tag at a guessed asset path would only add a 404.
class AppleTouchIconTest < Minitest::Test
  # Stand-ins for the Jekyll/al_utils filters, so the assertions can show exactly which
  # path was handed to each of them. They shadow the real filters when Jekyll has been
  # loaded by another test in the same process.
  module StubUrlFilters
    def relative_url(input)
      input.nil? ? nil : "/al-folio#{input}"
    end

    def bust_file_cache(input)
      "#{input}?v=stub"
    end
  end

  # `{% include %}` is Jekyll's tag, not core Liquid's; strip the includes so the
  # favicon block (which uses none of them) can be rendered standalone.
  HEAD = File.read(ROOT.join("_includes", "head.liquid").to_s, encoding: "UTF-8")
             .gsub(/\{%-?\s*include .*?-?%\}/m, "")

  EMOJI_ICON = "⚛️" # the template default: an atom emoji

  def render(site)
    Liquid::Template.parse(HEAD).render({ "site" => site, "page" => {} }, filters: [StubUrlFilters])
  end

  def apple_touch_icon_links(site)
    render(site).scan(/<link rel="apple-touch-icon"[^>]*>/)
  end

  def test_emoji_favicon_emits_no_apple_touch_icon
    out = render("icon" => EMOJI_ICON)

    assert_includes out, 'rel="shortcut icon"'
    assert_includes out, "data:image/svg+xml"
    assert_empty out.scan(/apple-touch-icon/),
                 "an emoji favicon has no raster asset to point at, so no tag should be emitted"
  end

  def test_configured_apple_touch_icon_resolves_under_assets_img
    assert_equal ['<link rel="apple-touch-icon" href="/al-folio/assets/img/apple-touch-icon.png?v=stub">'],
                 apple_touch_icon_links("icon" => EMOJI_ICON, "apple_touch_icon" => "apple-touch-icon.png")
  end

  def test_path_like_apple_touch_icon_is_not_prefixed_again
    assert_equal ['<link rel="apple-touch-icon" href="/al-folio/assets/icons/touch.png?v=stub">'],
                 apple_touch_icon_links("icon" => EMOJI_ICON, "apple_touch_icon" => "/assets/icons/touch.png")
  end

  def test_absolute_apple_touch_icon_url_is_left_alone
    assert_equal ['<link rel="apple-touch-icon" href="https://cdn.example.com/touch.png">'],
                 apple_touch_icon_links("icon" => EMOJI_ICON, "apple_touch_icon" => "https://cdn.example.com/touch.png")
  end

  def test_raster_image_favicon_is_reused_as_the_apple_touch_icon
    assert_equal ['<link rel="apple-touch-icon" href="/al-folio/assets/img/favicon.png?v=stub">'],
                 apple_touch_icon_links("icon" => "favicon.png")
    assert_equal ['<link rel="apple-touch-icon" href="/al-folio/assets/img/favicon.jpg?v=stub">'],
                 apple_touch_icon_links("icon" => "favicon.jpg")
  end

  def test_non_raster_image_favicon_is_not_reused
    # Safari accepts neither SVG nor ICO for apple-touch-icon, so reusing one would emit
    # a tag that iOS silently ignores.
    %w[favicon.svg favicon.ico].each do |icon|
      assert_empty apple_touch_icon_links("icon" => icon), "#{icon} should not be reused as an apple-touch-icon"
    end
  end

  def test_explicit_configuration_wins_over_the_favicon_fallback
    assert_equal ['<link rel="apple-touch-icon" href="/al-folio/assets/img/touch.png?v=stub">'],
                 apple_touch_icon_links("icon" => "favicon.png", "apple_touch_icon" => "touch.png")
  end

  def test_unset_icon_emits_no_icon_links_at_all
    # `site.icon != blank` is always true in plain Liquid (nil has no `blank?`), so an
    # unset icon used to emit `<link rel="shortcut icon" href="/assets/img/">`.
    out = render({})

    assert_empty out.scan(/rel="shortcut icon"/)
    assert_empty out.scan(/apple-touch-icon/)
    refute_includes out, "/assets/img/?v=stub"
  end
end
