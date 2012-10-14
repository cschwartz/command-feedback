# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'command_feedback/version'

Gem::Specification.new do |gem|
  gem.name          = "command_feedback"
  gem.version       = CommandFeedback::VERSION
  gem.authors       = ["Christian Schwartz"]
  gem.email         = ["christian.schwartz@gmail.com"]
  gem.description   = %q{An API and commandline tool for get-feedback.at}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "http://www.get-feedback.at"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "httparty"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "vcr"
end
