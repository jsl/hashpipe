require File.expand_path(File.join(File.dirname(__FILE__), %w[lib archived_attributes]))

ActiveRecord::Base.send(:include, ArchivedAttributes)

