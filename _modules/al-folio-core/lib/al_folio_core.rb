# frozen_string_literal: true

require "jekyll"
require "i18n"
require_relative "al_folio_core/version"

module AlFolioCore
  LEGACY_PATTERN = /
    data-(?:toggle|target|dismiss)\s*=\s*["'](?:collapse|dropdown|tooltip|popover|table|modal)["']|
    \b(?:jumbotron|input-group|form-group|form-row|modal(?:-dialog|-content|-header|-body|-footer)?|carousel(?:-\w+)?|alert(?:-\w+)?|badge-pill|pagination-lg)\b
  /x
  MIGRATIONS_DIR = File.expand_path("../migrations", __dir__)
  THEME_ROOT = File.expand_path("..", __dir__)

  module Tags
    class DetailsTag < Liquid::Block
      def initialize(tag_name, markup, tokens)
        super
        @caption = markup
      end

      def render(context)
        site = context.registers[:site]
        converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
        caption = converter.convert(@caption).gsub(%r{</?p[^>]*>}, "").chomp
        body = converter.convert(super(context))
        "<details><summary>#{caption}</summary>#{body}</details>"
      end
    end

    class FileExistsTag < Liquid::Tag
      def initialize(tag_name, path, tokens)
        super
        @path = path
      end

      def render(context)
        url = Liquid::Template.parse(@path).render(context)
        site_source = context.registers[:site].config["source"]
        file_path = "#{site_source}/#{url}"
        File.exist?(file_path.strip).to_s
      end
    end
  end

  module Filters
    module HideCustomBibtex
      def hideCustomBibtex(input)
        input = input.to_s
        keywords = Array(@context.registers[:site].config["filtered_bibtex_keywords"]).compact
        keywords.each do |keyword|
          input = input.gsub(/^.*\b#{keyword}\b *= *\{.*$\n/, "")
        end

        input.gsub(/^.*\bauthor\b *= *\{.*$\n/) { |line| line.gsub(/[*†‡§¶‖&^]/, "") }
      end
    end

    module CleanString
      class RemoveAccents
        I18n.config.available_locales = :en

        attr_accessor :string

        def initialize(string:)
          self.string = string
        end

        def digest!
          I18n.transliterate(string)
        end
      end

      def remove_accents(string)
        RemoveAccents.new(string: string).digest!
      end
    end
  end

  module JekyllTerserThemeGuard
    def generate(site)
      site.static_files.clone.each do |sf|
        next unless sf.kind_of?(Jekyll::StaticFile)
        next unless sf.path =~ /\.js$/
        next if sf.path.end_with?(".min.js")
        next unless AlFolioCore.local_source_asset?(sf.path, site.source)

        puts "Terser: Minifying #{sf.path}"
        site.static_files.delete(sf)
        name = File.basename(sf.path)
        destination = File.dirname(File.expand_path(sf.path)).sub(File.expand_path(site.source), "")
        js_file = Jekyll::Terser::JSFile.new(site, site.source, destination, name, @terser)
        site.static_files << js_file
      end
    end
  end

  module JekyllCacheBustThemeFallback
    private

    def directory_files_content
      local_target_path = File.join(directory, "**", "*")
      # jekyll-cache-bust calls `bust_css_cache` with directory "assets/_sass",
      # but the theme ships its Sass partials at "_sass" (the gem root), not
      # under "assets/". Without this mapping the glob matches nothing and the
      # cache-bust digest is the MD5 of an empty string, so main.css is never
      # re-versioned when the theme styles change. Resolve both the literal
      # configured path and the "assets/"-stripped theme location.
      theme_relative_path = File.join(directory.sub(%r{\Aassets/}, ""), "**", "*")

      files = Dir[local_target_path]
      files = Dir[File.join(AlFolioCore::THEME_ROOT, local_target_path)] if files.empty?
      files = Dir[File.join(AlFolioCore::THEME_ROOT, theme_relative_path)] if files.empty?
      if files.empty?
        files = Gem.path.flat_map do |gem_path|
          Dir[File.join(gem_path, "bundler", "gems", "*", local_target_path)] +
            Dir[File.join(gem_path, "gems", "*", local_target_path)] +
            Dir[File.join(gem_path, "bundler", "gems", "*", theme_relative_path)] +
            Dir[File.join(gem_path, "gems", "*", theme_relative_path)]
        end
      end

      files.map { |f| File.read(f) unless File.directory?(f) }.join
    end

    def file_content
      asset_index = file_name.index("assets/")
      local_file_name = asset_index ? file_name.slice(asset_index..-1) : file_name
      relative_file_name = local_file_name.sub(%r{^/+}, "")
      candidate_paths = [
        file_name,
        local_file_name,
        AlFolioCore.theme_asset_path(relative_file_name)
      ] + AlFolioCore.bundler_gem_asset_paths(relative_file_name)

      candidate_paths.uniq.each do |candidate_path|
        return File.read(candidate_path) if File.file?(candidate_path)
      end

      File.read(file_name)
    end
  end

  module JekyllMinifierEintrRetry
    def output_file(dest, content)
      attempts = 0

      begin
        super
      rescue Errno::EINTR
        attempts += 1
        retry if attempts < 4

        raise
      end
    end
  end

  module_function

  def compat_enabled?(site)
    site.config.dig("al_folio", "compat", "bootstrap", "enabled") == true
  end

  def markdown_and_template_files(site)
    roots = %w[_pages _includes _layouts]
    roots.flat_map do |root|
      Dir.glob(File.join(site.source, root, "**", "*.{md,markdown,html,liquid}"))
    end
  end

  def legacy_hits(site, limit: 5)
    hits = []

    markdown_and_template_files(site).each do |path|
      next unless File.file?(path)

      File.foreach(path).with_index(1) do |line, index|
        next unless line.match?(LEGACY_PATTERN)

        rel = path.sub(%r{^#{Regexp.escape(site.source)}/?}, "")
        hits << "#{rel}:#{index}"
        return hits if hits.length >= limit
      end
    end

    hits
  end

  def migration_manifest_paths
    Dir.glob(File.join(MIGRATIONS_DIR, "*.yml")).sort
  end

  def theme_asset_path(relative_asset_path)
    File.join(THEME_ROOT, relative_asset_path)
  end

  def bundler_gem_asset_paths(relative_asset_path)
    Gem.path.flat_map do |gem_path|
      Dir[File.join(gem_path, "bundler", "gems", "*", relative_asset_path)] +
        Dir[File.join(gem_path, "gems", "*", relative_asset_path)]
    end
  end

  def local_source_asset?(asset_path, site_source)
    expanded_asset_path = File.expand_path(asset_path)
    expanded_site_source = File.expand_path(site_source)
    return false unless expanded_asset_path.start_with?("#{expanded_site_source}#{File::SEPARATOR}")

    # Bundler-installed gems can live under `<site>/vendor/bundle/**`.
    # Treat those as external runtime assets, not local source overrides.
    vendored_bundle_prefix = File.join(expanded_site_source, "vendor", "bundle") + File::SEPARATOR
    return false if expanded_asset_path.start_with?(vendored_bundle_prefix)

    true
  end

  def patch_jekyll_terser_for_theme_assets!
    return unless defined?(Jekyll::Terser::TerserGenerator)

    generator = Jekyll::Terser::TerserGenerator
    return if generator.ancestors.include?(JekyllTerserThemeGuard)

    generator.prepend(JekyllTerserThemeGuard)
  end

  def patch_jekyll_cache_bust_for_theme_assets!
    return unless defined?(Jekyll::CacheBust::CacheDigester)

    cache_digester = Jekyll::CacheBust::CacheDigester
    return if cache_digester.ancestors.include?(JekyllCacheBustThemeFallback)

    cache_digester.prepend(JekyllCacheBustThemeFallback)
  end

  def patch_jekyll_minifier_for_notebook_output!
    return unless defined?(Jekyll::Compressor)

    [Jekyll::Document, Jekyll::Page, Jekyll::StaticFile].each do |klass|
      next if klass.ancestors.include?(JekyllMinifierEintrRetry)

      klass.prepend(JekyllMinifierEintrRetry)
    end
  end

  def jupyter_plugin_enabled?(site)
    Array(site.config["plugins"]).map(&:to_s).include?("jekyll-jupyter-notebook")
  end

  def command_available?(command)
    path_entries = ENV.fetch("PATH", "").split(File::PATH_SEPARATOR)
    return false if path_entries.empty?

    path_entries.any? do |path_entry|
      candidate = File.join(path_entry, command)
      File.file?(candidate) && File.executable?(candidate)
    end
  end

  def config_contract_violations(site)
    violations = []
    cfg = site.config
    api_version = cfg.dig("al_folio", "api_version")
    style_engine = cfg.dig("al_folio", "style_engine")
    tailwind_version = cfg.dig("al_folio", "tailwind", "version")
    tailwind_preflight = cfg.dig("al_folio", "tailwind", "preflight")
    tailwind_css_entry = cfg.dig("al_folio", "tailwind", "css_entry")
    distill_engine = cfg.dig("al_folio", "distill", "engine")
    distill_source = cfg.dig("al_folio", "distill", "source")

    violations << "expected `al_folio.api_version: 1` but found #{api_version.inspect}" unless api_version == 1
    violations << "expected `al_folio.style_engine: tailwind` but found #{style_engine.inspect}" unless style_engine == "tailwind"
    violations << "missing `al_folio.tailwind.version`" if tailwind_version.to_s.strip.empty?
    violations << "expected `al_folio.tailwind.preflight: false` for v1 parity mode" unless tailwind_preflight == false
    violations << "missing `al_folio.tailwind.css_entry`" if tailwind_css_entry.to_s.strip.empty?
    violations << "missing `al_folio.distill.engine`" if distill_engine.to_s.strip.empty?
    violations << "missing `al_folio.distill.source`" if distill_source.to_s.strip.empty?
    violations
  end
end

AlFolioCore.patch_jekyll_terser_for_theme_assets!
AlFolioCore.patch_jekyll_cache_bust_for_theme_assets!
AlFolioCore.patch_jekyll_minifier_for_notebook_output!
Liquid::Template.register_tag("details", AlFolioCore::Tags::DetailsTag)
Liquid::Template.register_tag("file_exists", AlFolioCore::Tags::FileExistsTag)
Liquid::Template.register_filter(AlFolioCore::Filters::HideCustomBibtex)
Liquid::Template.register_filter(AlFolioCore::Filters::CleanString)

Jekyll::Hooks.register :site, :after_init do |site|
  AlFolioCore.config_contract_violations(site).each do |violation|
    Jekyll.logger.warn("al_folio_core:", violation)
  end

  if AlFolioCore.jupyter_plugin_enabled?(site) && !AlFolioCore.command_available?("jupyter-nbconvert")
    Jekyll.logger.warn("al_folio_core:", "jekyll-jupyter-notebook is enabled but `jupyter-nbconvert` is not on PATH.")
    Jekyll.logger.warn("al_folio_core:", "Notebook rendering will be skipped for Jupyter posts until Python deps are installed.")
    Jekyll.logger.warn("al_folio_core:", "Install with `python3 -m pip install --user jupyter nbconvert`")
    Jekyll.logger.warn("al_folio_core:", "or run starter helper `./bin/setup-python-deps` if available.")
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  unless AlFolioCore.compat_enabled?(site)
    hits = AlFolioCore.legacy_hits(site)
    unless hits.empty?
      Jekyll.logger.warn("al_folio_core:", "legacy bootstrap-marked content detected while compatibility is disabled")
      Jekyll.logger.warn("al_folio_core:", "set `al_folio.compat.bootstrap.enabled: true` or run `bundle exec al-folio upgrade audit`")
      hits.each do |hit|
        Jekyll.logger.warn("al_folio_core:", "  #{hit}")
      end
    end
  end

  manifests = AlFolioCore.migration_manifest_paths
  if manifests.empty?
    Jekyll.logger.warn("al_folio_core:", "no migration manifests found under #{AlFolioCore::MIGRATIONS_DIR}")
  end
end
