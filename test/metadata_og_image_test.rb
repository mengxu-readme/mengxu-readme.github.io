# frozen_string_literal: true

require_relative "test_helper"
require "liquid"
require "al_folio_core"

# Regression test for og:image / twitter:image emitting absolute URLs.
# See https://github.com/alshedivat/al-folio/issues/3666 — external scrapers
# (Discord, LinkedIn, Mastodon) can't resolve relative image paths, so the
# link-preview image must be an absolute URL like og:url already is.
class MetadataOgImageTest < Minitest::Test
  METADATA = ROOT.join("_includes", "metadata.liquid").read

  def render(site:, page:)
    Liquid::Template.parse(METADATA).render("site" => site, "page" => page)
  end

  def base_site(extra = {})
    {
      "serve_og_meta" => true,
      "serve_schema_org" => false,
      "url" => "https://example.com",
      "baseurl" => "/al-folio",
      "title" => "Example",
      "first_name" => "Ada",
      "last_name" => "Lovelace",
    }.merge(extra)
  end

  def test_relative_page_og_image_becomes_absolute
    out = render(site: base_site, page: { "url" => "/", "og_image" => "/assets/img/foo.png" })

    assert_includes out, '<meta property="og:image" content="https://example.com/al-folio/assets/img/foo.png">'
    assert_includes out, '<meta name="twitter:image" content="https://example.com/al-folio/assets/img/foo.png">'
    refute_includes out, 'content="/assets/img/foo.png"'
  end

  def test_absolute_page_og_image_is_left_unchanged
    out = render(site: base_site, page: { "url" => "/", "og_image" => "https://cdn.example.com/x.png" })

    assert_includes out, '<meta property="og:image" content="https://cdn.example.com/x.png">'
    assert_includes out, '<meta name="twitter:image" content="https://cdn.example.com/x.png">'
  end

  def test_site_og_image_fallback_becomes_absolute
    site = base_site("og_image" => "/default.png", "baseurl" => "")
    out = render(site: site, page: { "url" => "/" })

    assert_includes out, '<meta property="og:image" content="https://example.com/default.png">'
  end

  def test_no_og_image_emits_no_image_meta
    out = render(site: base_site, page: { "url" => "/" })

    refute_includes out, "og:image"
    refute_includes out, "twitter:image"
  end
end
