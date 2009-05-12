Gem::Specification.new do |s|
  s.name     = "hashpipe"
  s.version  = "0.0.3"
  s.date     = "2009-05-12"
  s.summary  = "ActiveRecord plugin to save content to a pluggable, hash-style backend"
  s.email    = "justin@phq.org"
  s.homepage = "http://github.com/jsl/hashpipe"
  s.description = "HashPipe connects an AR-backed model to a key-value store"
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
    "lib/hashpipe/backends/memcache.rb",
    "lib/hashpipe/backends/filesystem.rb"
  ]
  s.test_files = [
    "spec/hashpipe/global_configuration_spec.rb",
    "spec/hashpipe/archived_attribute_spec.rb",
    "spec/hashpipe/backends/filesystem_spec.rb",
    "spec/hashpipe/backends/s3_spec.rb",
    "spec/hashpipe/backends/memcache_spec.rb"
  ]
  s.add_dependency("activesupport", ["> 0.0.0"])
  s.add_dependency("right_aws", ["> 0.0.0"])
  s.add_dependency("assaf-uuid", ["> 0.0.0"])
end
