require File.expand_path('../lib/newrelic_httprb/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tiago Sousa"]
  gem.email         = ["tiago.joao@gmail.com"]
  gem.description   = %q{New Relic instrumentation for http.rb}
  gem.summary       = %q{New Relic instrumentation for http.rb}
  gem.homepage      = "https://github.com/Talkdesk/newrelic_httprb"
  gem.license       = "MIT"

  gem.files         = Dir["{lib}/**/*.rb", "LICENSE", "*.md"]
  gem.name          = "newrelic_httprb"
  gem.require_paths = ["lib"]
  gem.version       = NewRelicHTTP::VERSION
  gem.add_dependency 'newrelic_rpm', '~> 3.11'
  gem.add_dependency 'http'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'test-unit'
end
