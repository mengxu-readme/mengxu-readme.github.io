# frozen_string_literal: true

require_relative "test_helper"
require "al_folio_core"
require "fileutils"
require "tmpdir"

class ThemeRuntimeGuardTest < Minitest::Test
  LEGACY_OR_PLUGIN_OWNED_ASSETS = %w[
    assets/css/academicons.min.css
    assets/css/bootstrap-toc.min.css
    assets/css/bootstrap.min.css
    assets/css/mdb.min.css
    assets/css/scholar-icons.css
    assets/css/tikzjax.min.css
    assets/js/bootstrap-toc.min.js
    assets/js/bootstrap.bundle.min.js
    assets/js/chartjs-setup.js
    assets/js/diff2html-setup.js
    assets/js/echarts-setup.js
    assets/js/leaflet-setup.js
    assets/js/mathjax-setup.js
    assets/js/mermaid-setup.js
    assets/js/newsletter.js
    assets/js/plotly-setup.js
    assets/js/pseudocode-setup.js
    assets/js/search-setup.js
    assets/js/shortcut-key.js
    assets/js/tabs.min.js
    assets/js/tikzjax.min.js
    assets/js/vanilla-back-to-top.min.js
    assets/js/vega-setup.js
  ].freeze

  def test_local_source_asset_detection
    site_source = "/tmp/site"
    local_path = "/tmp/site/assets/js/app.js"
    gem_path = "/tmp/bundler/gems/al-folio-core-123/assets/js/app.js"
    vendored_bundle_path = "/tmp/site/vendor/bundle/ruby/3.3.0/gems/al_folio_core-1.1.0/assets/js/app.js"

    assert AlFolioCore.local_source_asset?(local_path, site_source)
    refute AlFolioCore.local_source_asset?(gem_path, site_source)
    refute AlFolioCore.local_source_asset?(vendored_bundle_path, site_source)
  end

  def test_bootstrap_compat_assets_are_cache_busted
    head = ROOT.join("_includes/head.liquid").read
    scripts = ROOT.join("_includes/scripts.liquid").read

    assert_includes head, "bootstrap-compat.css' | relative_url | bust_file_cache"
    assert_includes scripts, "bootstrap-compat.js' | relative_url | bust_file_cache"
  end

  def test_theme_asset_path_points_to_packaged_assets
    tailwind_path = AlFolioCore.theme_asset_path("assets/css/tailwind.css")
    compat_css_path = AlFolioCore.theme_asset_path("assets/css/bootstrap-compat.css")
    compat_js_path = AlFolioCore.theme_asset_path("assets/js/bootstrap-compat.js")
    cv_include_path = AlFolioCore.theme_asset_path("_includes/cv/education.liquid")
    distill_scripts_include_path = AlFolioCore.theme_asset_path("_includes/distill_scripts.liquid")

    assert File.file?(tailwind_path), "expected #{tailwind_path} to exist"
    refute File.file?(compat_css_path), "bootstrap compat CSS should be owned by al_folio_bootstrap_compat"
    refute File.file?(compat_js_path), "bootstrap compat JS should be owned by al_folio_bootstrap_compat"
    refute File.file?(cv_include_path), "cv includes should be owned by al_folio_cv"
    refute File.file?(distill_scripts_include_path), "distill scripts include should be owned by al_folio_distill"
  end

  def test_bundler_gem_asset_paths_can_locate_core_assets
    paths = AlFolioCore.bundler_gem_asset_paths("assets/css/tailwind.css")
    assert paths.is_a?(Array)
    assert paths.all? { |path| File.file?(path) }
  end

  def test_bundler_gem_asset_paths_supports_rubygems_and_bundler_layouts
    Dir.mktmpdir do |tmp_dir|
      bundler_path = File.join(tmp_dir, "bundler", "gems", "al_folio_distill-1.0.0", "assets", "css")
      rubygems_path = File.join(tmp_dir, "gems", "al_folio_cv-1.0.0", "assets", "css")
      FileUtils.mkdir_p(bundler_path)
      FileUtils.mkdir_p(rubygems_path)
      File.write(File.join(bundler_path, "al-folio-distill.css"), "/* distill */")
      File.write(File.join(rubygems_path, "al-folio-cv.css"), "/* cv */")

      original_gem_path = Gem.path
      Gem.singleton_class.send(:define_method, :path) { [tmp_dir] }

      distill_paths = AlFolioCore.bundler_gem_asset_paths("assets/css/al-folio-distill.css")
      cv_paths = AlFolioCore.bundler_gem_asset_paths("assets/css/al-folio-cv.css")

      assert_equal [File.join(bundler_path, "al-folio-distill.css")], distill_paths
      assert_equal [File.join(rubygems_path, "al-folio-cv.css")], cv_paths
    ensure
      Gem.singleton_class.send(:define_method, :path) { original_gem_path }
    end
  end

  def test_wrapper_layouts_delegate_to_plugin_includes
    cv_layout = ROOT.join("_layouts/cv.liquid").read
    distill_layout = ROOT.join("_layouts/distill.liquid").read

    assert_includes cv_layout, "{% al_folio_cv_render %}"
    assert_includes distill_layout, "{% al_folio_distill_render %}"
  end

  def test_legacy_and_plugin_owned_assets_are_not_packaged_by_core
    LEGACY_OR_PLUGIN_OWNED_ASSETS.each do |asset_path|
      refute ROOT.join(asset_path).file?, "expected #{asset_path} to be removed from al_folio_core"
    end
  end

  def test_plugin_owned_directories_are_not_packaged_by_core
    refute ROOT.join("assets/js/search").directory?, "search runtime assets are owned by al_search"
    refute ROOT.join("_sass/font-awesome").directory?, "font-awesome styles are owned by al_icons"
  end

  def test_jupyter_plugin_detection_and_command_checks
    enabled_site = Struct.new(:config).new({ "plugins" => ["jekyll-jupyter-notebook"] })
    disabled_site = Struct.new(:config).new({ "plugins" => ["jekyll-feed"] })

    assert AlFolioCore.jupyter_plugin_enabled?(enabled_site)
    refute AlFolioCore.jupyter_plugin_enabled?(disabled_site)
    assert AlFolioCore.command_available?("ruby")
  end

  def test_minifier_output_retries_interrupted_file_writes
    writer = Class.new do
      prepend AlFolioCore::JekyllMinifierEintrRetry

      attr_reader :attempts

      def output_file(dest, content)
        @attempts = (@attempts || 0) + 1
        raise Errno::EINTR if attempts == 1

        [dest, content]
      end
    end.new

    assert_equal ["index.html", "<main></main>"], writer.output_file("index.html", "<main></main>")
    assert_equal 2, writer.attempts
  end
end
