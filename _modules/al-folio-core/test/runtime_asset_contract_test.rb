# frozen_string_literal: true

require_relative "test_helper"

class RuntimeAssetContractTest < Minitest::Test
  def test_giscus_setup_script_is_shipped_via_scripts_collection
    path = ROOT.join("_scripts/giscus-setup.js")
    assert path.file?, "expected #{path} to exist"

    content = path.read
    assert_includes content, "permalink: /assets/js/giscus-setup.js"
    assert_includes content, "https://giscus.app/client.js"
  end

  def test_cookie_plugin_wrappers_are_shipped
    styles_wrapper = ROOT.join("_includes/plugins/al_cookie_styles.liquid")
    scripts_wrapper = ROOT.join("_includes/plugins/al_cookie_scripts.liquid")

    assert styles_wrapper.file?, "expected #{styles_wrapper} to exist"
    assert scripts_wrapper.file?, "expected #{scripts_wrapper} to exist"
    assert_includes styles_wrapper.read, "{% al_cookie_styles %}"
    assert_includes scripts_wrapper.read, "{% al_cookie_scripts %}"
  end

  def test_scripts_include_uses_cookie_plugin_wrapper
    scripts_include = ROOT.join("_includes/scripts.liquid").read
    assert_includes scripts_include, "{% include plugins/al_cookie_scripts.liquid %}"
  end

  def test_head_include_uses_cookie_plugin_wrapper
    head_include = ROOT.join("_includes/head.liquid").read
    assert_includes head_include, "{% include plugins/al_cookie_styles.liquid %}"
  end

  def test_head_include_uses_icons_plugin_wrapper
    head_include = ROOT.join("_includes/head.liquid").read
    assert_includes head_include, "{% include plugins/al_icons_styles.liquid %}"
  end

  def test_back_to_top_uses_cdn_library_contract
    scripts_include = ROOT.join("_includes/scripts.liquid").read
    assert_includes scripts_include, "third_party_libraries['vanilla-back-to-top'].url.js"
  end

  def test_related_posts_include_uses_single_list_wrapper
    related_posts_include = ROOT.join("_includes/related_posts.liquid").read

    assert_match(/<ul[^>]*>\s*{% for post in related_posts %}/m, related_posts_include)
    refute_match(/<ul[^>]*><\/ul>/, related_posts_include)
  end

  def test_toc_contract_uses_tocbot_runtime
    head_include = ROOT.join("_includes/head.liquid").read
    scripts_include = ROOT.join("_includes/scripts.liquid").read
    default_layout = ROOT.join("_layouts/default.liquid").read
    common_js = ROOT.join("assets/js/common.js").read

    assert_includes head_include, "third_party_libraries.tocbot.url.css"
    assert_includes scripts_include, "third_party_libraries.tocbot.url.js"
    assert_includes common_js, "window.tocbot.init"
    assert_includes default_layout, "data-toc-collapse"
    assert_includes default_layout, "data-toc-collapse-depth"
    assert_includes common_js, "resolveTocCollapseDepth"
  end

  def test_pretty_table_contract_loads_tailwind_engine_when_bootstrap_compat_is_disabled
    scripts_include = ROOT.join("_includes/scripts.liquid").read

    assert_includes scripts_include, "page.pretty_table and site.al_folio.compat.bootstrap.enabled != true"
    assert_includes scripts_include, "/assets/js/table-engine.js"
  end

  def test_core_scripts_do_not_require_jquery
    masonry_js = ROOT.join("assets/js/masonry.js").read
    jupyter_js = ROOT.join("assets/js/jupyter_new_tab.js").read

    refute_match(/\$\(/, masonry_js)
    refute_match(/\$\(/, jupyter_js)
  end
end
