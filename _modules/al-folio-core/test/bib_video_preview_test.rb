# frozen_string_literal: true

require_relative "test_helper"
require "liquid"

# Regression test for video files used as publication previews.
# See https://github.com/alshedivat/al-folio/issues/3564 — `preview = {clip.mp4}` used
# to be rendered through the image path and produced a broken <img>.
class BibVideoPreviewTest < Minitest::Test
  BIB = File.read(ROOT.join("_layouts", "bib.liquid").to_s, encoding: "UTF-8")
  VIDEO = File.read(ROOT.join("_includes", "video.liquid").to_s, encoding: "UTF-8")

  PREVIEW_BLOCK_START = "{% if entry.preview %}"

  # Slice the `{% if entry.preview %}` … `{% endif %}` block out of the layout so it can
  # be rendered on its own: the surrounding layout uses Jekyll-only tags (`file_exists`,
  # `highlight`, `inspirehep_citations`) that core Liquid cannot parse.
  def self.extract_block(source, opening)
    start = source.index(opening) or raise "#{opening} not found in template"
    position = start
    depth = 0

    while (match = source.match(/\{%-?(.*?)-?%\}/m, position))
      tag = match[1].strip.split(/\s/).first
      position = match.end(0)
      depth += 1 if %w[if unless for case comment raw].include?(tag)
      next unless %w[endif endunless endfor endcase endcomment endraw].include?(tag)

      depth -= 1
      return source[start...position] if depth.zero?
    end

    raise "unbalanced block starting at #{opening}"
  end

  # Jekyll's `{% include %}` cannot run under core Liquid; swap each one for a marker so
  # the test can assert which branch the preview was routed to.
  PREVIEW_BLOCK = extract_block(BIB, PREVIEW_BLOCK_START)
                  .gsub(/\{%-?\s*include\s+(\S+?\.liquid).*?-?%\}/m) { "[[include #{Regexp.last_match(1)}]]" }
  # Trailing probes expose the paths the block computed for each branch.
  PROBED_PREVIEW_BLOCK = "#{PREVIEW_BLOCK}|video=={{ preview_video_path }}|image=={{ entry_path }}"

  def render_preview(preview)
    Liquid::Template.parse(PROBED_PREVIEW_BLOCK).render({ "entry" => { "preview" => preview } })
  end

  def probe(preview, name)
    render_preview(preview)[/\|#{name}==([^|]*)/, 1].to_s.strip
  end

  def test_video_previews_are_delegated_to_the_video_include
    %w[clip.mp4 clip.webm clip.ogg clip.mov].each do |preview|
      out = render_preview(preview)

      assert_includes out, "[[include video.liquid]]", "#{preview} should render through video.liquid"
      refute_includes out, "[[include figure.liquid]]"
      refute_includes out, "<img"
      assert_equal "/assets/img/publication_preview/#{preview}", probe(preview, "video")
    end
  end

  def test_video_preview_extension_matching_is_case_insensitive_and_ignores_query_strings
    assert_includes render_preview("clip.MP4"), "[[include video.liquid]]"
    assert_equal "https://example.com/clip.mp4?raw=1", probe("https://example.com/clip.mp4?raw=1", "video")
  end

  def test_image_previews_still_render_through_the_figure_include
    out = render_preview("paper.png")

    assert_includes out, "[[include figure.liquid]]"
    refute_includes out, "[[include video.liquid]]"
    assert_equal "/assets/img/publication_preview/paper.png", probe("paper.png", "image")
  end

  def test_remote_image_previews_still_render_as_a_bare_img_tag
    out = render_preview("https://example.com/paper.png")

    assert_includes out, '<img class="preview z-depth-1 rounded" src="https://example.com/paper.png">'
    refute_includes out, "[[include video.liquid]]"
  end

  def test_image_branch_markup_is_unchanged
    # The image path must stay byte-identical; only the routing around it is new.
    assert_includes BIB, <<~LIQUID.chomp
      {% elsif entry.preview contains '://' %}
                <img class="preview z-depth-1 rounded" src="{{ entry.preview }}">
              {% else %}
                {% assign entry_path = entry.preview | prepend: '/assets/img/publication_preview/' %}
                {%
                  include figure.liquid
                  loading="eager"
                  path=entry_path
                  sizes = "200px"
                  class="preview z-depth-1 rounded"
                  zoomable=true
                  avoid_scaling=true
                  alt=entry.preview
                %}
    LIQUID
  end

  def test_preview_video_include_requests_playback_controls
    assert_includes BIB, "{% include video.liquid path=preview_video_path class=\"preview z-depth-1 rounded\" controls=true %}"
  end

  # Stand-in for the Jekyll/al_utils URL filters, which need a live site register.
  module StubUrlFilters
    def relative_url(input)
      input.nil? ? nil : "/al-folio#{input}"
    end

    def bust_file_cache(input)
      "#{input}?v=stub"
    end
  end

  def render_video(path, params = {})
    Liquid::Template.parse(VIDEO).render({ "include" => { "path" => path }.merge(params) }, filters: [StubUrlFilters])
  end

  def test_video_include_treats_every_extension_the_bib_layout_routes_to_it_as_a_video
    # A mismatch between the two lists is silent: video.liquid falls back to an <iframe>,
    # which renders an empty frame for a local file.
    %w[clip.mp4 clip.webm clip.ogg clip.mov clip.MOV clip.mp4?raw=1].each do |path|
      out = render_video(path)

      assert_includes out, "<video", "#{path} should render as a <video> element"
      refute_includes out, "<iframe"
    end
  end

  def test_video_include_still_falls_back_to_an_iframe_for_embeds
    out = render_video("https://www.youtube.com/embed/abc?rel=0")

    assert_includes out, "<iframe"
    refute_includes out, "<video"
  end

  def test_local_video_source_is_resolved_against_the_site_baseurl
    assert_includes render_video("/assets/img/publication_preview/clip.mp4"),
                    'src="/al-folio/assets/img/publication_preview/clip.mp4"'
  end

  def test_video_include_emits_controls_when_requested
    assert_includes render_video("clip.mp4", "controls" => true), "controls"
    refute_includes render_video("clip.mp4"), "controls"
  end

  def test_video_previews_are_constrained_to_the_thumbnail_column
    # A <video> has no intrinsic responsive sizing, so without this rule it renders at
    # its 300x150 default and overflows the abbr/preview column.
    styles = File.read(ROOT.join("_sass", "_publications.scss").to_s, encoding: "UTF-8")

    assert_match(/video\.preview\s*\{[^}]*max-width:\s*100%/m, styles)
  end
end
