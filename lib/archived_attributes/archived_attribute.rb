require 'activesupport'

require File.expand_path(File.join(File.dirname(__FILE__),  
    %w[ backends filesystem ]))

require File.expand_path(File.join(File.dirname(__FILE__),  %w[ backends s3 ]))

module ArchivedAttributes
  
  class ArchivedAttribute
    attr_reader :name, :instance

    def initialize(name, instance, opts = {})
      @name     = name
      @instance = instance
      @dirty    = false

      @_options = ArchivedAttributes::GlobalConfiguration.instance.to_hash.
        merge(opts)

      @backend = instantiate_backend_from(options)
    end
    
    def value
      val = defined?(@stashed_value) ? @stashed_value : @backend.load
      val = compress? ? Zlib::Inflate.inflate(val) : val
      val = marshal? ? Marshal.load(val) : val
    end

    def value=(other)
      other = marshal? ? Marshal.dump(other) : other
      other = compress? ? Zlib::Deflate.deflate(other) : other
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

    # Returns a backend object based on the options given (e.g., filesystem,
    # s3).
    def instantiate_backend_from(options)
      "ArchivedAttributes::Backends::#{options[:storage].to_s.camelize}".
        constantize.new(self)
    end

    def options
      @_options
    end

    private

    [:marshal, :compress].each do |sym|
      define_method("#{sym}?") do                   # def marshal?
        options[sym].nil? ? false : options[sym]    #   options[:marshal].nil? ? false : options[:marshal]
      end                                           # end
    end

  end
  
end