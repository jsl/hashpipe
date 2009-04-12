Gem::Specification.new do |s|
  s.name     = "hashpipe"
  s.version  = "0.0.2"
  s.date     = "2009-04-12"
  s.summary  = "Rails plugin to save content to a pluggable, hash-style backend"
  s.email    = "justin@phq.org"
  s.homepage = "http://github.com/jsl/hashpipe"
  s.description = "HashPipe allows for data to be saved to a backend other than the rdbms"
  s.has_rdoc = true
  s.authors  = ["Justin Leitgeb"]
  s.files    = [
    "Rakefile",
    "hashpipe.gemspec",
    "init.rb",
    "config/hashpipe.yml",
    "lib/hashpipe.rb",
    "lib/hashpipe/archived_attribute.rb",
    "lib/hashpipe/global_configuration.rb",
    "lib/hashpipe/backends/s3.rb",
    "lib/hashpipe/backends/filesystem.rb"
  ]
  s.test_files = [
    "spec/hashpipe/global_configuration_spec.rb",
    "spec/hashpipe/archived_attribute_spec.rb",
    "spec/hashpipe/backends/filesystem_spec.rb",
    "spec/hashpipe/backends/s3_spec.rb"
  ]
  
  s.add_dependency("right_aws", ["> 0.0.0"])
  s.add_dependency("assaf-uuid", ["> 0.0.0"])
end
