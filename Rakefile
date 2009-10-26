require 'rake'
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ratpack"
    gem.summary = %Q{A set of view helpers for Sinatra. Inspired by Rails' ActionView helpers}
    gem.description = %Q{link_to, content_tag, stylesheet_link_tag, javascript_include_tag, etc}
    gem.email = "zeke@sikelianos.com"
    gem.homepage = "http://github.com/zeke/ratpack"
    gem.authors = ["Zeke Sikelianos"]

    gem.files = %w{TODO VERSION.yml} + FileList['lib/**/*.rb', 'test/**/*.rb', 'examples/**/*']    
    gem.add_runtime_dependency 'rack', '>=1.0.0'
    gem.add_runtime_dependency 'sinatra', '>=0.9.1'
    gem.add_development_dependency 'rack-test', '>=0.3.0'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies
task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ratpack #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end