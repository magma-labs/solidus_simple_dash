# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)
require 'solidus_simple_dash/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_simple_dash'
  s.version     = SolidusSimpleDash::VERSION
  s.summary     = 'Overview dashboard for use with Solidus.'
  s.description = s.summary
  s.license     = 'BSD-3-Clause'

  s.author    = 'Jonathan Tapia'
  s.email     = 'jonathan.tapia@magmalabs.io'
  s.homepage  = 'http://github.com/magma-labs/solidus_simple_dash'
  s.license   = 'BSD-3-Clause'

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'solidus', ['>= 2.0', '< 3']
  s.add_dependency 'solidus_auth_devise', ['>= 2.0', '< 3']
  s.add_dependency 'solidus_support'
  s.add_dependency 'deface', '~> 1.0'
  s.add_dependency 'jqplot-rails'

  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'solidus_dev_support'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
