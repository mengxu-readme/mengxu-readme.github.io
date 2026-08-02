# frozen_string_literal: true

require "minitest/autorun"
require "pathname"

ROOT = Pathname.new(File.expand_path("..", __dir__)) unless defined?(ROOT)

# Hooks for plugins that are not bundled with core.
#
# These are the "two lists must agree" contract in practice: core may only
# reference a plugin tag from inside a `site.plugins contains` guard, because an
# unguarded custom tag is a parse error on every site that has not installed the
# gem — which takes the whole build down, not just the feature.
class PluginHooksTest < Minitest::Test
  NEW_PLUGINS = {
    "al_rtl" => %w[al_rtl_html_attrs al_rtl_styles],
    "al_email_protect" => %w[al_email_protect_styles al_email_protect_scripts],
    "al_marimo" => %w[al_marimo_styles al_marimo_scripts],
  }.freeze

  def wrapper_path(tag)
    ROOT.join("_includes/plugins/#{tag}.liquid")
  end

  def test_every_new_plugin_has_a_parse_safe_wrapper
    NEW_PLUGINS.each_value do |tags|
      tags.each do |tag|
        assert_path_exists wrapper_path(tag)
        assert_match(/\{%-?\s*#{Regexp.escape(tag)}\s*-?%\}/, File.read(wrapper_path(tag)))
      end
    end
  end

  def test_wrappers_invoke_only_their_own_tag
    NEW_PLUGINS.each_value do |tags|
      tags.each do |tag|
        body = File.read(wrapper_path(tag)).gsub(/\{%-?\s*comment.*?endcomment\s*-?%\}/m, "")
        invoked = body.scan(/\{%-?\s*(\w+)\s*-?%\}/).flatten

        assert_equal [tag], invoked, "#{tag}.liquid should invoke exactly its own tag"
      end
    end
  end

  def test_html_attrs_wrapper_controls_whitespace
    # Its output lands inside the <html> tag; an uncontrolled newline would sit
    # between the tag name and its attributes.
    body = File.read(wrapper_path("al_rtl_html_attrs"))

    assert_includes body, "{%- al_rtl_html_attrs -%}"
  end

  def test_new_plugin_includes_are_guarded_by_a_plugins_check
    sources = {
      "_includes/head.liquid" => File.read(ROOT.join("_includes/head.liquid")),
      "_includes/scripts.liquid" => File.read(ROOT.join("_includes/scripts.liquid")),
      "_layouts/default.liquid" => File.read(ROOT.join("_layouts/default.liquid")),
    }

    NEW_PLUGINS.each do |plugin, tags|
      tags.each do |tag|
        sources.each do |name, body|
          next unless body.include?("plugins/#{tag}.liquid")

          # Find the nearest preceding guard and assert it names this plugin.
          preceding = body.split("plugins/#{tag}.liquid").first
          guard = preceding.scan(/\{%-?\s*if [^%]*site\.plugins contains '([a-z_]+)'/).flatten.last

          assert_equal plugin, guard, "#{name} includes #{tag} without a `site.plugins contains '#{plugin}'` guard"
        end
      end
    end
  end

  def test_default_layout_still_emits_an_html_tag_without_al_rtl
    # The fallback branch must keep rendering a valid document for the majority
    # of sites, which do not install al_rtl.
    body = File.read(ROOT.join("_layouts/default.liquid"))

    assert_includes body, %(lang="{{ site.lang }}")
    assert_includes body, "site.plugins contains 'al_rtl'"
  end

  def test_html_tag_stays_a_single_static_element
    # The attributes are captured into a variable rather than the <html> tag
    # being wrapped in {% if %}. That is not cosmetic: a conditional there stops
    # Prettier seeing a static root element, and it re-indents the entire
    # document body — turning a 15-line change into a 130-line diff on the most
    # frequently reviewed layout in the theme.
    body = File.read(ROOT.join("_layouts/default.liquid"))

    assert_includes body, "<html {{ html_attributes }}>"
    refute_match(/\{%-?\s*if [^%]*%\}\s*<html/, body, "<html> must not be wrapped in a conditional")
  end
end
