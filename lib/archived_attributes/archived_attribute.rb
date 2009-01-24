require 'activesupport'

require File.expand_path(File.join(File.dirname(__FILE__),  %w[ backends filesystem ]))
require File.expand_path(File.join(File.dirname(__FILE__),  %w[ backends s3 ]))

module ArchivedAttributes
  
  class ArchivedAttribute
    attr_accessor :name, :instance, :options


    def self.default_options
      {
        :storage  => :filesystem,
        :path     => File.join( File.dirname(__FILE__), %w[ .. .. tmp archived_attribute ] )
      }
    end

    def initialize(name, instance, options = {})
      @name     = name
      @instance = instance

      @options = self.class.default_options.merge(options)
      
      @backend = 
        "ArchivedAttributes::Backends::#{@options[:storage].to_s.camelize}".
        constantize.new(self)
      
      @dirty = false
    end

    def value
      defined?(@stashed_value) ? @stashed_value : @backend.load
    end

    def value=(other)
      @stashed_value = other
      @dirty = true
    end

    def dirty?
      @dirty
    end

    # First saves this record to the back-end.  If backend storage raises an
    # error, we capture it and add it to the AR validation errors.
    def save
      @backend.save(@stashed_value) if self.dirty?
    end

  end
  
end