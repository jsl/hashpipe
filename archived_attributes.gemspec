Gem::Specification.new do |s|
  s.name     = "archived_attributes"
  s.version  = "0.0.1"
  s.date     = "2009-01-25"
  s.summary  = "Rails plugin to save content to a pluggable back-end"
  s.email    = "justin@phq.org"
  s.homepage = "http://github.com/jsl/archived_attributes"
  s.description = "ArchivedAttributes allows for data to be saved to a backend other than the rdbms"
  s.has_rdoc = true
  s.authors  = ["Justin Leitgeb"]
  s.files    = [
    "Rakefile",
    "archived_attributes.gemspec",
    "init.rb",
    "config/archived_attributes.yml",
    "lib/archived_attributes.rb",
    "lib/archived_attributes/archived_attribute.rb",
    "lib/archived_attributes/global_configuration.rb",
    "lib/archived_attributes/backends/s3.rb",
    "lib/archived_attributes/backends/filesystem.rb"
  ]
  s.test_files = [
    "spec/archived_attributes/global_configuration_spec.rb",
    "spec/archived_attributes/archived_attribute_spec.rb",
    "spec/archived_attributes/backends/filesystem_spec.rb",
    "spec/archived_attributes/backends/s3_spec.rb"
  ]
  s.add_dependency("right_aws", ["> 0.0.0"])
end
