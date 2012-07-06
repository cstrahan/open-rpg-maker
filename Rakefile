require 'rake/testtask'

TEST_PATTERN = 'test/**/*_test.rb'

desc 'Default: run tests.'
task :default => ['test']

desc "Run tests."
Rake::TestTask.new("test") do |t|
  t.libs << 'lib'
  t.pattern = TEST_PATTERN
  t.verbose = false
  t.warning = false
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

task :dos2unix do
  require 'rbconfig'

  Dir.chdir(File.expand_path("..", __FILE__)) do
    if RbConfig::CONFIG['host_os'] =~ /linux/
      sh %{find . -name '*.*rb' -exec sed -i 's/\r//g' {} \\;}
    elsif RbConfig::CONFIG['host_os'] =~ /darwin/
      sh %{find . -name '*.*rb' -exec sed -i '' 's/\r//' {} \\;}
    else
      puts "This doesn't work on systems other than OSX or Linux. Please use a custom whitespace tool for your platform '#{RbConfig::CONFIG["host_os"]}'."
    end
  end
end
