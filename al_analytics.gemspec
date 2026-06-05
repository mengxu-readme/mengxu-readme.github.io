Gem::Specification.new do |spec|
  spec.name          = "al_analytics"
  spec.version       = "1.0.0"
  spec.authors       = ["al-org"]
  spec.email         = ["dev@al-org.dev"]
  spec.summary       = "Analytics integration tags for al-folio Jekyll sites"
  spec.description   = "Jekyll plugin extracted from al-folio that renders Google Analytics, Cronitor RUM, Pirsch, and OpenPanel scripts with optional cookie-consent attributes."
  spec.homepage      = "https://github.com/al-org-dev/al-analytics"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7"

  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage
  }

  spec.files         = Dir["lib/**/*", "LICENSE", "README.md", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll", ">= 3.9", "< 5.0"
  spec.add_dependency "liquid", ">= 4.0", "< 6.0"

  spec.add_development_dependency "bundler", ">= 2.0", "< 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
