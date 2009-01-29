require 'activesupport'

require File.expand_path(File.join(File.dirname(__FILE__),  %w[ backends filesystem ]))
require File.expand_path(File.join(File.dirname(__FILE__),  %w[ backends s3 ]))

module ArchivedAttributes
  
  class ArchivedAttribute
    attr_reader :name, :instance, :options

    def initialize(name, instance, options = {})
      @name     = name
      @instance = instance
      @dirty    = false

      @options = ArchivedAttributes::GlobalConfiguration.instance.to_hash.merge(options)

      @backend = instantiate_backend_from(@options)
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

    def destroy
      @backend.destroy
    end

    # Returns a backend object based on the options given (e.g., filesystem, s3).
    def instantiate_backend_from(options)
      "ArchivedAttributes::Backends::#{options['default_storage'].to_s.camelize}".
        constantize.new(self)
    end

  end
  
end