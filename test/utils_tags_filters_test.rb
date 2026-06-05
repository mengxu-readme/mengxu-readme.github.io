# frozen_string_literal: true

require_relative "test_helper"
require "liquid"
require "tmpdir"
require "fileutils"
require "al_folio_core"

class UtilsTagsFiltersTest < Minitest::Test
  class FakeConverter
    def convert(input)
      "<p>#{input.strip}</p>\n"
    end
  end

  class FakeSite
    attr_reader :config

    def initialize(source:, filtered_keywords: [])
      @config = {
        "source" => source,
        "filtered_bibtex_keywords" => filtered_keywords,
      }
    end

    def find_converter_instance(_klass)
      FakeConverter.new
    end
  end

  def test_details_tag_wraps_summary_and_body
    site = FakeSite.new(source: Dir.pwd)
    template = Liquid::Template.parse("{% details Summary %}Body text{% enddetails %}")

    output = template.render({}, registers: { site: site })

    assert_includes output, "<details><summary>Summary</summary>"
    assert_includes output, "<p>Body text</p>"
    assert_includes output, "</details>"
  end

  def test_file_exists_tag_checks_site_source
    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p(File.join(dir, "assets"))
      File.write(File.join(dir, "assets", "example.txt"), "ok")
      site = FakeSite.new(source: dir)

      template = Liquid::Template.parse("{% file_exists assets/example.txt %}")
      output = template.render({}, registers: { site: site })

      assert_equal "true", output
    end
  end

  def test_hide_custom_bibtex_filter_removes_configured_fields
    site = Object.new
    site.instance_variable_set(:@config, { "filtered_bibtex_keywords" => ["file", "doi"] })
    site.define_singleton_method(:config) { @config }
    context = Struct.new(:registers).new({ site: site })

    host = Object.new
    host.extend(AlFolioCore::Filters::HideCustomBibtex)
    host.instance_variable_set(:@context, context)

    input = <<~BIB
      file = {paper.pdf}
      author = {Doe, John*}
      doi = {10.1234/example}
    BIB

    output = host.hideCustomBibtex(input)

    refute_includes output, "file ="
    refute_includes output, "doi ="
    assert_includes output, "author = {Doe, John}"
  end

  def test_remove_accents_filter_transliterates_text
    host = Object.new
    host.extend(AlFolioCore::Filters::CleanString)

    assert_equal "Cafe naive facade", host.remove_accents("Caf\u00e9 na\u00efve fa\u00e7ade")
  end
end
