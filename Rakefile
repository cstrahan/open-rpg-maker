require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'yard'

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

desc 'Removes trailing whitespace across the entire application.'
task :whitespace do
  require 'rbconfig'

  Dir.chdir(File.expand_path("..", __FILE__)) do
    if RbConfig::CONFIG['host_os'] =~ /linux/
      sh %{find . -name '*.*rb' -exec sed -i 's/\t/ /g' {} \\; -exec sed -i 's/ *$//g' {} \\; }
    elsif RbConfig::CONFIG['host_os'] =~ /darwin/
      sh %{find . -name '*.*rb' -exec sed -i '' 's/\t/ /g' {} \\; -exec sed -i '' 's/ *$//g' {} \\; }
    else
      puts "This doesn't work on systems other than OSX or Linux. Please use a custom whitespace tool for your platform '#{RbConfig::CONFIG["host_os"]}'."
    end
  end
end
