require File.expand_path(File.join(File.dirname(__FILE__), %w[lib hashpipe]))

ActiveRecord::Base.send(:include, HashPipe)

