require 'rake'
require 'rake/testtask'

test_pattern = 'test/*_test.rb'

desc "Run tests."
Rake::TestTask.new("test") do |t|
  t.libs << 'lib'
  t.pattern = test_pattern
  t.verbose = false
  t.warning = false
end

desc 'Default: run tests.'
task :default => ['test']