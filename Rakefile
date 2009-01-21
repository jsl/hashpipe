require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'

require File.join(File.dirname(__FILE__), %w[ spec spec_helper ])

desc 'Test the plugin.'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << 'lib'
  t.verbose = true
end

desc "Run all the tests"
task :default => :spec

desc 'Generate documentation for the compressed_attributes plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ArchivedAttributes'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
