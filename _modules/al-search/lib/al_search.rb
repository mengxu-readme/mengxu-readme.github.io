require 'jekyll'
require 'liquid'

module AlSearch
  PLUGIN_NAME = 'al_search'
  ASSETS_DIR = 'assets'
  JS_DIR = 'js'

  class PluginStaticFile < Jekyll::StaticFile; end

  class AssetsGenerator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      plugin_lib_path = File.expand_path('.', __dir__)
      search_asset_root = File.join(plugin_lib_path, ASSETS_DIR, PLUGIN_NAME, JS_DIR)
      Dir.glob(File.join(search_asset_root, '**', '*')).each do |source_path|
        next if File.directory?(source_path)

        relative_dir = File.dirname(source_path).sub("#{plugin_lib_path}/", '')
        file_name = File.basename(source_path)
        site.static_files << PluginStaticFile.new(site, plugin_lib_path, relative_dir, file_name)
      end
    end
  end

  class SearchAssetsTag < Liquid::Tag
    def render(context)
      site = context.registers[:site]
      return '' unless site
      return '' unless site.config['search_enabled']

      baseurl = site.config['baseurl'] || ''
      payload = site.site_payload
      payload['page'] = context.registers[:page] || {}
      payload['paginator'] = context['paginator'] if context['paginator']

      template_path = File.expand_path('templates/search-data.liquid.js', __dir__)
      template = Liquid::Template.parse(File.read(template_path))
      search_data = template.render(payload, registers: context.registers)

      <<~HTML
        <script type="module" src="#{baseurl}/assets/al_search/js/search/ninja-keys.min.js"></script>
        <ninja-keys hideBreadcrumbs noAutoLoadMdIcons placeholder="Type to start searching"></ninja-keys>
        <script src="#{baseurl}/assets/al_search/js/search-setup.js"></script>
        <script>
        #{search_data}
        </script>
        <script src="#{baseurl}/assets/al_search/js/shortcut-key.js"></script>
      HTML
    end
  end
end

Liquid::Template.register_tag('al_search_assets', AlSearch::SearchAssetsTag)
