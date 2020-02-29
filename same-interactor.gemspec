# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'same/interactor/version'

Gem::Specification.new do |spec|
  spec.name          = 'same-interactor'
  spec.version       = Same::Interactor::VERSION
  spec.authors       = ['Jokūbas Pučinskas']
  spec.email         = ['maillerpucinskas@gmail.com', 'po.jurcys@gmail.com']

  spec.summary       = 'Interactor on steroids.'
  spec.description   = 'Improved interactor with validations and mandatory arguments.'
  spec.homepage      = 'https://github.com/samesystem/same-interactor'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/samesystem/same-interactor'
    spec.metadata['changelog_uri'] = "https://github.com/samesystem/same-interactor/blob/v#{Same::Interactor::VERSION}/CHANGELOG.md"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'interactor', '~> 3.0'
  spec.add_dependency 'rails', '>= 5.0', '< 7.0'
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rspec'
end
