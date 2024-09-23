require File.expand_path('../lib/dm-types/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors     = ['Dan Kubb']
  gem.email       = ['dan.kubb@gmail.com']
  gem.summary     = 'DataMapper plugin providing extra data types'
  gem.description = "#{gem.summary} for use in data models"
  gem.license = 'Nonstandard'
  gem.homepage = 'https://datamapper.org'

  gem.files            = `git ls-files`.split("\n")
  gem.extra_rdoc_files = %w(LICENSE README.rdoc)

  gem.name          = 'sbf-dm-types'
  gem.require_paths = %w(lib)
  gem.version       = DataMapper::Types::VERSION
  gem.required_ruby_version = '>= 2.7.8'

  gem.add_runtime_dependency('bcrypt',      '~> 3.0')
  gem.add_runtime_dependency('sbf-dm-core',     '~> 1.3.0.beta')
  gem.add_runtime_dependency('fastercsv',   '~> 1.5.4')
  gem.add_runtime_dependency 'multi_json', '~> 1.7', '>= 1.7.7'
  gem.add_runtime_dependency('safe_yaml', '~> 0.6.1')
  gem.add_runtime_dependency 'stringex', '~> 2.0', '>= 2.0.8'
  gem.add_runtime_dependency('uuidtools', '~> 2.1.2')
end
