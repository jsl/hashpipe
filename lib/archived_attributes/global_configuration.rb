module ArchivedAttributes

  # Singleton class for reading the defaults archived attribute configuration
  # for this environment.
  class GlobalConfiguration
    include Singleton

    DEFAULTS = HashWithIndifferentAccess.new({
      :default_storage => :filesystem,
      :s3 => {
        :protocol => 'https'
      }
    })
    
    def [](val)
      config[val]
    end

    def config
      @config ||= HashWithIndifferentAccess.new(
        DEFAULTS.merge(load_yaml_configuration)
      )
    end
    alias :to_hash :config

    def to_s
      config.inspect
    end

    private

    def load_yaml_configuration
      YAML.load_file(
        File.join( RAILS_ROOT, 'config', 'archived_attributes.yml' )
      )[RAILS_ENV]
    end
  end

end