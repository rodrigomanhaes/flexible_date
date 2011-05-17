# encoding: utf-8

Gem::Specification.new do |s|
  s.name = 'flexible_date'
  s.version = '0.1.1'
  s.date = %q{2011-04-29}
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.author = 'Rodrigo Manhães'
  s.description = 'Make ActiveRecord understand any date format you want.'
  s.email = 'rmanhaes@gmail.com'
  s.homepage = 'https://github.com/rodrigomanhaes/flexible_date'
  s.summary = 'Make possible enter date fields in any format into your ActiveRecord models'

  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']

  s.files = Dir.glob('lib/**/*.rb') + %w(README.rdoc LICENSE.txt)
  s.add_dependency('activerecord', '~> 3.0.0')
  s.add_development_dependency('sqlite3-ruby', '~> 1.3.0')
  s.add_development_dependency('rspec', '~> 2.5.0')
end
