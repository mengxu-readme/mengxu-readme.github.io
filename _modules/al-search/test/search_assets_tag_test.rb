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

    # Jekyll's `where` filter memoizes property lookups through the registered
    # site, so the fake has to expose the same cache a real Jekyll::Site does.
    def filter_cache
      @filter_cache ||= {}
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

  def test_home_nav_entry_uses_title_of_page_with_root_permalink
    payload = minimal_payload
    payload['site']['pages'] = [
      { 'permalink' => '/blog/', 'title' => 'Blog' },
      { 'permalink' => '/', 'title' => '  Home Page  ' }
    ]

    output, = render_assets(
      config: { 'search_enabled' => true, 'baseurl' => '' },
      payload: payload
    )

    assert_includes output, 'title: "Home Page"'
    # The home entry must come from the page whose permalink is "/", not simply
    # the first page in the list.
    refute_includes output, 'Blog'
    # An invalid filter chain (e.g. `| first.title`) silently drops the property
    # lookup and leaks the whole page hash into the generated JavaScript.
    refute_includes output, 'permalink'
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
