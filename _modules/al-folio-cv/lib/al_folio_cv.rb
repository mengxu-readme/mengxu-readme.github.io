# frozen_string_literal: true

require "jekyll"
require_relative "al_folio_cv/version"

module AlFolioCv
  PLUGIN_ROOT = File.expand_path("..", __dir__)
  TEMPLATES_ROOT = File.join(PLUGIN_ROOT, "templates")
  ASSETS_ROOT = File.join(PLUGIN_ROOT, "assets")

  class PluginStaticFile < Jekyll::StaticFile; end

  module_function

  def enabled?(site)
    site.config.dig("al_folio", "features", "cv", "enabled") != false
  end

  class AssetsGenerator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      return unless AlFolioCv.enabled?(site)

      Dir.glob(File.join(ASSETS_ROOT, "**", "*")).sort.each do |source_path|
        next if File.directory?(source_path)

        relative_dir = File.dirname(source_path).sub("#{PLUGIN_ROOT}/", "")
        site.static_files << PluginStaticFile.new(site, PLUGIN_ROOT, relative_dir, File.basename(source_path))
      end
    end
  end

  class RenderTag < Liquid::Tag
    def render(context)
      site = context.registers[:site]
      return "" unless site && AlFolioCv.enabled?(site)

      Liquid::Template.parse("{% include cv/render.liquid %}").render!(
        context.environments.first,
        registers: context.registers
      )
    end
  end
end

Liquid::Template.register_tag("al_folio_cv_render", AlFolioCv::RenderTag)

Jekyll::Hooks.register :site, :after_init do |site|
  next unless site.respond_to?(:includes_load_paths)

  include_path = AlFolioCv::TEMPLATES_ROOT
  site.includes_load_paths << include_path unless site.includes_load_paths.include?(include_path)
end
