# frozen_string_literal: true

require_relative "lib/jekyll-socials/version"

Gem::Specification.new do |s|
  s.name        = "jekyll-socials"
  s.summary     = "Add beautiful social links to your Jekyll site."
  s.description = "Add beautiful social links to your Jekyll site using Academicons, FontAwesome, and Social Icons."
  s.version     = Jekyll::Socials::VERSION
  s.authors     = ["George Corrêa de Araújo"]
  s.homepage    = "https://george-gca.github.io/jekyll-socials/"
  s.licenses    = ["MIT"]

  # https://guides.rubygems.org/specification-reference/#metadata
  s.metadata      = {
    "source_code_uri" => "https://github.com/george-gca/jekyll-socials",
    "bug_tracker_uri" => "https://github.com/george-gca/jekyll-socials/issues",
    "changelog_uri"   => "https://github.com/george-gca/jekyll-socials/releases",
    "homepage_uri"    => s.homepage,
  }

  all_files     = `git ls-files -z`.split("\x0")
  s.files       = all_files.grep(%r!^(lib)/!)

  s.required_ruby_version = ">= 2.3.0"

  s.add_dependency "jekyll", ">= 3.6", "< 5.0"
end
