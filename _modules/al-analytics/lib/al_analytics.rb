require "jekyll"

module AlAnalytics
  class AnalyticsTag < Liquid::Tag
    def render(context)
      site = context.registers[:site]
      return "" unless site

      output = []
      cookie_attrs = cookie_consent_attrs(site)

      google_id = analytics_value(site, "google_analytics", "google")
      if enabled?(site, "enable_google_analytics", google_id)
        output << <<~HTML
          <!-- Google Analytics -->
          <script#{cookie_attrs} async src="https://www.googletagmanager.com/gtag/js?id=#{google_id}"></script>
          <script#{cookie_attrs}>
            window.dataLayer = window.dataLayer || [];
            function gtag() {
              window.dataLayer.push(arguments);
            }
            gtag("js", new Date());
            gtag("config", "#{google_id}");
          </script>
        HTML
      end

      cronitor_id = analytics_value(site, "cronitor_analytics", "cronitor")
      if enabled?(site, "enable_cronitor_analytics", cronitor_id)
        output << <<~HTML
          <!-- Cronitor RUM -->
          <script#{cookie_attrs} async src="https://rum.cronitor.io/script.js"></script>
          <script#{cookie_attrs}>
            window.cronitor =
              window.cronitor ||
              function () {
                (window.cronitor.q = window.cronitor.q || []).push(arguments);
              };
            cronitor("config", { clientKey: "#{cronitor_id}" });
          </script>
        HTML
      end

      pirsch_id = analytics_value(site, "pirsch_analytics", "pirsch")
      if enabled?(site, "enable_pirsch_analytics", pirsch_id)
        output << <<~HTML
          <script#{cookie_attrs} defer src="https://api.pirsch.io/pa.js" id="pianjs" data-code="#{pirsch_id}"></script>
        HTML
      end

      openpanel_id = analytics_value(site, "openpanel_analytics", "openpanel")
      if enabled?(site, "enable_openpanel_analytics", openpanel_id)
        output << <<~HTML
          <script#{cookie_attrs}>
            window.op =
              window.op ||
              function (...args) {
                (window.op.q = window.op.q || []).push(args);
              };
            window.op("init", {
              clientId: "#{openpanel_id}",
              trackScreenViews: true,
              trackOutgoingLinks: true,
              trackAttributes: true,
            });
          </script>
          <script#{cookie_attrs} async defer src="https://openpanel.dev/op1.js"></script>
        HTML
      end

      output.join("\n")
    end

    private

    def cookie_consent_attrs(site)
      site.config["enable_cookie_consent"] ? ' type="text/plain" data-category="analytics"' : ""
    end

    def analytics_value(site, key, legacy_key)
      value = site.config[key]
      return value unless value_blank?(value)

      legacy_config = site.config["analytics"]
      return nil unless legacy_config.is_a?(Hash)

      legacy_config[legacy_key]
    end

    def enabled?(site, flag_key, value)
      return false if value_blank?(value)

      flag = site.config[flag_key]
      return true if flag.nil?

      !!flag
    end

    def value_blank?(value)
      value.nil? || value.to_s.strip.empty?
    end
  end
end

Liquid::Template.register_tag("al_analytics_scripts", AlAnalytics::AnalyticsTag)
