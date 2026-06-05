# frozen_string_literal: true

require_relative "test_helper"
require "al_folio_cv"

class RuntimeContractTest < Minitest::Test
  def test_render_template_exists
    assert ROOT.join("templates/cv/render.liquid").file?
  end

  def test_assets_are_packaged
    assert ROOT.join("assets/css/al-folio-cv.css").file?
  end

  def test_render_tag_registered
    assert_equal AlFolioCv::RenderTag, Liquid::Template.tags["al_folio_cv_render"]
  end
end
