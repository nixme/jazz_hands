# -*- encoding: utf-8 -*-

require File.expand_path('../lib/jazz_hands/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'jazz_hands'
  gem.version       = JazzHands::VERSION
  gem.author        = 'Gopal Patel'
  gem.email         = 'nixme@stillhope.com'
  gem.license       = 'MIT'
  gem.homepage      = 'https://github.com/nixme/jazz_hands'
  gem.summary       = 'Exercise those fingers. Pry-based enhancements for the default Rails console.'
  gem.description   = "Spending hours in the rails console? Spruce it up and show off those hard-working hands! jazz_hands replaces IRB with Pry, improves output through awesome_print, and has some other goodies up its sleeves."

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ['lib']

  # Dependencies
  gem.required_ruby_version = '>= 1.9.2'
  gem.add_runtime_dependency 'pry', '~> 0.9.12'
  gem.add_runtime_dependency 'pry-rails', '~> 0.3.2'
  gem.add_runtime_dependency 'pry-doc', '~> 0.4.6'
  gem.add_runtime_dependency 'pry-git', '~> 0.2.3'
  gem.add_runtime_dependency 'pry-stack_explorer', '~> 0.4.9'
  gem.add_runtime_dependency 'pry-remote', '>= 0.1.7'
  gem.add_runtime_dependency 'pry-debugger', '~> 0.2.2'
  gem.add_runtime_dependency 'hirb', '~> 0.7.1'
  gem.add_runtime_dependency 'coolline', '>= 0.4.2'
  gem.add_runtime_dependency 'awesome_print', '~> 1.2'
  gem.add_runtime_dependency 'railties', '>= 3.0', '< 5.0'
end
