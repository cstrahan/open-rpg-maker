require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'yard'
require 'spec/rake/spectask'

TEST_PATTERN = 'test/**/*_test.rb'

desc 'Default: run tests.'
task :default => ['test']

desc "Run tests."
Rake::TestTask.new("test") do |t|
  t.libs << 'lib'
  t.pattern = TEST_PATTERN
  t.verbose = false
  t.warning = false
  t.ruby_opts << '-r turn' if Gem.available?('turn')
end

require 'rcov/rcovtask'
desc "Run test coverage."
Rcov::RcovTask.new("rcov") do |rcov|
  rcov.libs << 'test'
  rcov.pattern = TEST_PATTERN
end

YARD::Rake::YardocTask.new do |t|
  t.options += ['--title', "Open RPG Maker Documentation"]
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'html'
  rdoc.title = "Open RPG Maker Documentation"
end