# frozen_string_literal: true

require_relative 'lib/solidus_simple_dash/version'

Gem::Specification.new do |s|
  s.name = 'solidus_simple_dash'
  s.version = SolidusSimpleDash::VERSION
  s.authors = ['Jonathan Tapia']
  s.email = 'jonathan.tapia@magmalabs.io'

  s.summary = 'Overview dashboard for use with Solidus'
  s.description = s.summary
  s.homepage = 'http://github.com/magma-labs/solidus_simple_dash'
  s.license = 'BSD-3-Clause'

  if s.respond_to?(:metadata)
    s.metadata['homepage_uri'] = s.homepage if s.homepage
    s.metadata['source_code_uri'] = s.homepage if s.homepage
  end

  s.required_ruby_version = Gem::Requirement.new('>= 2.5')

  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  s.files = files.grep_v(%r{^(test|spec|features)/})
  s.test_files = files.grep(%r{^(test|spec|features)/})
  s.bindir = "exe"
  s.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'solidus_core', ['>= 2.5', '< 4']
  s.add_dependency 'solidus_backend', ['>= 2.5', '< 4']
  s.add_dependency 'solidus_support', '~> 0.5'
  s.add_dependency 'deface', '~> 1.0'
  s.add_dependency 'jqplot-rails'

  s.add_development_dependency 'solidus_dev_support', '~> 2.3'
  s.add_development_dependency 'autoprefixer-rails', '~> 10.2.5'
  s.add_development_dependency 'rspec-activemodel-mocks'
  s.add_development_dependency 'shoulda-matchers'
end
