require 'minitest/autorun'
require 'liquid'

require_relative '../lib/al_search'

class AlSearchAssetsTagTest < Minitest::Test
  class FakeSite
    attr_reader :config, :static_files

    def initialize(config:, payload:)
      @config = config
      @payload = payload
      @static_files = []
    end

    def site_payload
      @payload
    end
  end

  def render_assets(config:, payload:, page: {})
    site = FakeSite.new(config: config, payload: payload)
    template = Liquid::Template.parse('{% al_search_assets %}')
    output = template.render({}, registers: { site: site, page: page })
    [output, site]
  end

  def minimal_payload
    {
      'site' => {
        'pages' => [{ 'permalink' => '/', 'title' => 'About' }],
        'posts' => [],
        'collections' => [],
        'data' => { 'socials' => {} },
        'socials_in_search' => false,
        'posts_in_search' => false
      }
    }
  end

  def test_renders_search_assets_when_enabled
    output, = render_assets(
      config: { 'search_enabled' => true, 'baseurl' => '/base' },
      payload: minimal_payload
    )

    assert_includes output, '<ninja-keys'
    assert_includes output, '/base/assets/al_search/js/search/ninja-keys.min.js'
    assert_includes output, '/base/assets/al_search/js/search-setup.js'
    assert_includes output, '/base/assets/al_search/js/shortcut-key.js'
  end

  def test_returns_empty_when_search_disabled
    output, = render_assets(
      config: { 'search_enabled' => false, 'baseurl' => '/base' },
      payload: minimal_payload
    )

    assert_equal '', output
  end

  def test_assets_generator_registers_search_files
    site = FakeSite.new(config: { 'search_enabled' => true }, payload: minimal_payload)

    AlSearch::AssetsGenerator.new.generate(site)

    names = site.static_files.map(&:name)
    assert_includes names, 'search-setup.js'
    assert_includes names, 'shortcut-key.js'
    assert_includes names, 'ninja-keys.min.js'
  end

  def test_search_setup_uses_vanilla_nav_closure
    setup_script = File.read(File.expand_path('../lib/assets/al_search/js/search-setup.js', __dir__))

    refute_includes setup_script, '$("#navbarNav")'
    refute_includes setup_script, '.collapse("hide")'
    assert_includes setup_script, 'window.openSearchModal = openSearchModal'
    assert_includes setup_script, 'data-nav-toggle="navbarNav"'
    assert_includes setup_script, 'document.getElementById("search-toggle")'
    assert_includes setup_script, 'event.preventDefault()'
  end
end
