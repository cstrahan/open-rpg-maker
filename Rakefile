# TODO: Come up with some way to display missing dependancies...

require 'rake'
require 'rake/testtask'
require 'yard'

test_pattern = 'test/*_test.rb'

desc 'Default: run tests.'
task :default => ['test']

desc "Run tests."
Rake::TestTask.new("test") do |t|
  t.libs << 'lib'
  t.pattern = test_pattern
  t.verbose = false
  t.warning = false
end

require 'rcov/rcovtask'
desc "Run test coverage."
Rcov::RcovTask.new(:rcov) do |rcov|
  rcov.libs << 'test'
  rcov.pattern = 'test/**/*_test.rb'
end

desc "Generate documentation."
YARD::Rake::YardocTask.new("yard") do |t|
  t.options += ['--title', "Open RPG Maker Documentation"]
end
